variable "bucket_name" {
  type        = string
  description = "S3 bucket to store the Terraform state"
}

variable "region" {
  type        = string
  description = "AWS region where S3 bucket is located"
}
