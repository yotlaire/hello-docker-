variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "subnet_public_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for the public subnet"
}

variable "subnet_private_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR block for the private subnet"
}

variable "lambda_runtime" {
  type        = string
  default     = "nodejs16.x"
  description = "Runtime environment for the Lambda function"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name for the DynamoDB table"
}

variable "dynamodb_hash_key" {
  type        = string
  description = "Hash key attribute name for the DynamoDB table"
}

variable "dynamodb_attribute_type" {
  type        = string
  default     = "S"
  description = "Data type for the DynamoDB table's hash key"
}

variable "availability_zone" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of Availability Zones for the subnets"
}