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
  filename      = data.archive_file.archive_lambda_function.output_path
  function_name = "mane041_sqs_image_generation"
  runtime       = "python3.12"
  role          = aws_iam_role.mane041_lambda_role.arn
  timeout       = 45
  handler       = "mane041_sqs_image_generation.lambda_handler"

  environment {
    variables = {
      BUCKET_NAME      = "pgr301-couch-explorers"
      CANDIDATE_NUMBER = "17"
    }
  }
}

resource "aws_sqs_queue" "mane041_sqs_queue" {
  name                       = "mane041_sqs_queue"
  max_message_size           = 1024
  visibility_timeout_seconds = 180
}

resource "aws_lambda_event_source_mapping" "mane041_sqs_event" {
  function_name    = aws_lambda_function.mane041_sqs_image_generation.arn
  event_source_arn = aws_sqs_queue.mane041_sqs_queue.arn
  batch_size       = 1
}

resource "aws_iam_role" "mane041_lambda_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "mane_041_lambda_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::pgr301-couch-explorers"
      },
      {
        Effect   = "Allow"
        Action   = "bedrock:InvokeModel"
        Resource = "arn:aws:bedrock:us-east-1"
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = aws_sqs_queue.mane041_sqs_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "mane_041_policy_attachment" {
  role       = aws_iam_role.mane041_lambda_role.name
  policy_arn = aws_iam_policy.mane_041_lambda_policy.arn
}

data "archive_file" "archive_lambda_function" {
  type        = "zip"
  source_file = "${path.module}/../lambda_sqs.py"
  output_path = "${path.module}/../function.zip"
}