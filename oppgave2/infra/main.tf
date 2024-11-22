terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source of the AWS provider
      version = "~> 5.74.0"     # Use a version of the AWS provider that is compatible with version
    }
  }

  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "17/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_lambda_function" "mane041_sqs_image_generation" {
  filename      = "../lambda_sqs.py"
  function_name = "mane041_sqs_image_generation"
  runtime       = "python3.12"
  role          = "aws_iam_role.mane041_lambda_role.arn"

  environment {
    variables = {
      BUCKET_NAME      = "pgr301-couch-explorers"
      CANDIDATE_NUMBER = "17"
    }
  }
}

resource "aws_sqs_queue" "mane041_sqs_queue" {

}

resource "aws_iam_policy" "mane041_lambda_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
        ]
        Resource = "arn:aws:s3:::pgr301-couch-explorers"
      },
      {
        Effect   = "Allow"
        Action   = "bedrock:InvokeModel"
        Resource = "arn:aws:bedrock:us-east-1"
      }
    ]
  })
}

resource "aws_iam_role" "mane041_lambda_role" {
  assume_role_policy = ""
}