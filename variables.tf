variable "bucket_name" {
  type        = string
  description = "S3 bucket to store the Terraform state"
  default     = "rsschool-devops-terraform-state"
}

variable "region" {
  type        = string
  description = "AWS region where S3 bucket is located"
  default     = "us-east-1"
}
