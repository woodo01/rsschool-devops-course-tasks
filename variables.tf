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

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  default     = "DevOpsTask2"
}

variable "ami-ec2-images" {
  description = "Which AMI use."
  default = {
    eu-central-1 = "ami-0084a47cc718c111a"
  }
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
