variable "aws_region" {
  description = "AWS Region to deploy our infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix for tags"
  type        = string
  default     = "aryan-cloud"
}

variable "vpc_cidr" {
  description = "Base CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of Availability Zones for High Availability"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the 2 Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the 2 Private Subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
