variable "bucket_names" {
  description = "Map of logical bucket names to globally unique S3 bucket names."

  type = object({
    landing    = string
    bronze     = string
    quarantine = string
    scripts    = string
  })
}

variable "force_destroy" {
  description = "Whether Terraform can delete non-empty buckets. Keep false for shared or production environments."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Whether S3 bucket versioning should be enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the S3 resources."
  type        = map(string)
  default     = {}
}