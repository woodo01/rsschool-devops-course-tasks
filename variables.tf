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

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  description = "Which AMI use."
  default     = "ami-0000000"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}
