import sys
import hashlib
import boto3
import json

from datetime import datetime, timezone

from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql.functions import (
    col,
    current_timestamp,
    input_file_name,
    lit
)


args = getResolvedOptions(
    sys.argv,
    [
        "JOB_NAME",
        "JOB_RUN_ID",
        "environment",
        "aws_region",
        "report_name",
        "source_system",
        "source_format",
        "target_format",
        "target_database",
        "source_path",
        "target_path",
        "quarantine_path",
        "audit_lambda_name",
        "mandatory_field",
        "pipeline_name",
        "dataset_name",
        "target_table"
    ]
)


sc = SparkContext.getOrCreate()
glue_context = GlueContext(sc)
spark = glue_context.spark_session
logger = glue_context.get_logger()

job = Job(glue_context)
job.init(args["JOB_NAME"], args)


glue_run_id = args["JOB_RUN_ID"]
audit_started_utc = datetime.now(timezone.utc)

source_path = args["source_path"]
target_path = args["target_path"]
quarantine_base_path = args["quarantine_path"].rstrip("/")

source_format = args["source_format"]
target_format = args["target_format"]

mandatory_field = args["mandatory_field"]

lambda_client = boto3.client(
    "lambda",
    region_name=args["aws_region"]
)


def send_audit_record(audit_row):
    payload = {
        "row": audit_row
    }

    response = lambda_client.invoke(
        FunctionName=args["audit_lambda_name"],
        InvocationType="RequestResponse",
        Payload=json.dumps(payload).encode("utf-8")
    )

    result = json.loads(
        response["Payload"].read().decode("utf-8")
    )

    if response.get("FunctionError"):
        raise RuntimeError(
            f"Run log writer Lambda failed: {result}"
        )

    if result.get("status") != "SUCCESS":
        raise RuntimeError(
            f"Audit write was not confirmed: {result}"
        )

    logger.info(
        f"Audit record inserted: {json.dumps(result)}"
    )

    return result


logger.info(
    f"Landing-to-bronze job started. "
    f"Environment={args['environment']}, "
    f"Source={source_path}, "
    f"Target={target_path}"
)


reader = spark.read.format(source_format)

if source_format.lower() == "json":
    reader = (
        reader
        .option("multiLine", "true")
        .option("mode", "FAILFAST")
    )

df = reader.load(source_path)


input_count = df.count()

if input_count == 0:
    raise ValueError("Source data is empty")

logger.info(f"Input record count: {input_count}")


if mandatory_field not in df.columns:
    raise ValueError(
        f"Required field is missing: {mandatory_field}"
    )


invalid_df = df.filter(
    col(mandatory_field).isNull()
)

null_count = invalid_df.count()


if null_count > 0:
    quarantine_df = invalid_df.withColumn(
        "rejection_reason",
        lit(f"Null value in {mandatory_field}")
    )

    input_id = hashlib.sha256(
        source_path.encode("utf-8")
    ).hexdigest()[:16]

    quarantine_path = (
        f"{quarantine_base_path}/"
        f"{args['source_system']}/"
        f"{args['dataset_name']}/"
        f"negative_test/"
        f"input_id={input_id}/"
    )

    (
        quarantine_df
        .write
        .mode("overwrite")
        .parquet(quarantine_path)
    )

    logger.info(
        f"Quarantined {null_count} invalid records "
        f"at {quarantine_path}"
    )


logger.info("Null-value validation completed")


valid_df = df.filter(
    col(mandatory_field).isNotNull()
)

valid_count = valid_df.count()

logger.info(
    f"Valid records available for bronze: {valid_count}"
)


bronze_df = (
    valid_df
    .withColumn(
        "_ingestion_timestamp",
        current_timestamp()
    )
    .withColumn(
        "_source_file",
        input_file_name()
    )
    .withColumn(
        "_source_system",
        lit(args["source_system"])
    )
    .withColumn(
        "_report_name",
        lit(args["report_name"])
    )
)


if valid_count > 0:
    (
        bronze_df
        .write
        .format(target_format)
        .mode("errorifexists")
        .save(target_path)
    )

    logger.info(
        f"Bronze data write completed at {target_path}"
    )
else:
    logger.info(
        "No valid records. Skipping bronze write."
    )


logger.info(
    f"Processed valid records: {valid_count}"
)


audit_completed_utc = datetime.now(timezone.utc)


audit_row = {
    "run_id": glue_run_id,
    "parent_run_id": None,
    "report": args["report_name"],
    "pipeline": args["pipeline_name"],
    "step": "l2b",
    "service": "GLUE",
    "service_run_id": glue_run_id,
    "execution_arn": None,
    "attempt": 1,
    "source": args["source_system"],
    "dataset": args["dataset_name"],
    "target_table": args["target_table"],
    "run_mode": (
        "SCHEDULED"
        if args["environment"]
        else "ON_DEMAND"
    ),
    "status": "SUCCESS",
    "started_utc": (
        audit_started_utc
        .isoformat()
        .replace("+00:00", "Z")
    ),
    "ended_utc": (
        audit_completed_utc
        .isoformat()
        .replace("+00:00", "Z")
    ),
    "rows_in": input_count,
    "rows_out": valid_count
}


send_audit_record(audit_row)

job.commit()

logger.info("Landing-to-bronze job completed")