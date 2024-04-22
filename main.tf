# Define the VPC
resource "aws_vpc" "lambda_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Lambda VPC"
  }
}

# Define the public subnet
resource "aws_subnet" "lambda_public_subnet" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.subnet_public_cidr
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "Lambda Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "lambda_private_subnet" {
  vpc_id            = aws_vpc.lambda_vpc.id
  cidr_block        = var.subnet_private_cidr
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "Lambda Private Subnet"
  }
}

# Define the private route table
resource "aws_route_table" "lambda_private_rt" {
  vpc_id = aws_vpc.lambda_vpc.id

  tags = {
    Name = "Lambda Private Route Table"
  }
}

# Associate the private route table with the private subnet
resource "aws_route_table_association" "lambda_private_rt_association" {
  subnet_id      = aws_subnet.lambda_private_subnet.id
  route_table_id = aws_route_table.lambda_private_rt.id
}

# Define the security group
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  vpc_id      = aws_vpc.lambda_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH access for initial setup (optional)
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Define the DynamoDB VPC endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.lambda_vpc.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.lambda_private_rt.id]
}

# Define the Lambda execution role
resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Define the Lambda function
resource "aws_lambda_function" "lambda_action" {
  function_name = "lambda-action"
  filename      = "deploy.zip"
  handler       = "handler.handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_exec_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.lambda_private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# Define the DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"

  hash_key = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_hash_key
    type = var.dynamodb_attribute_type
  }
}