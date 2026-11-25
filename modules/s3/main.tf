resource "aws_s3_bucket" "this" {
  for_each = var.bucket_names

  bucket        = each.value
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name    = each.value
      Purpose = each.key
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = aws_s3_bucket.this

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = var.enable_versioning ? aws_s3_bucket.this : {}

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}