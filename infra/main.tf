terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source = "hashicorp/aws" # Specify the source of the AWS provider
      version = "~> 5.74.0"        # Use a version of the AWS provider that is compatible with version
    }
  }

  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key = "17/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_lambda_function" "mane041_sqs_image_generation" {
  tags = {
    Name = "ExampleInstance" # Tag the instance with a Name tag for easier identification
  }
  function_name = "mane041_sqs_image_generation"
}

resource "aws_iam_policy" "lambda_role" {
  policy = ""
}