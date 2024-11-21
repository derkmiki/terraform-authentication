terraform {
  required_version = "~>1.9.2"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.65.0"
    }
    archive = {
        source = "hashicorp/archive"
        version = "~>2.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "lambda_function" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_function" {
  name = "${var.prefix}-lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_function.json
}


data "archive_file" "lambda" {
  for_each = toset(var.sources)
  source_dir = "${var.source_root}/${each.value}"
  output_path = "${var.source_root}/${each.value}.zip"
  type = "zip"
}

resource "aws_lambda_function" "lambda_function" {
  for_each =  {
    for index, archive in data.archive_file.lambda: 
      index => archive
  }
  function_name = "${var.prefix}-${each.key}"
  runtime = "nodejs20.x"
  role = aws_iam_role.lambda_function.arn
  handler = "main.handler"
  filename = each.value.output_path
  source_code_hash = each.value.output_base64sha256

  tags = {
    config_name = each.key
  }
}

#lambda logging
resource "aws_cloudwatch_log_group" "lambda_logging" {
  for_each = {
    for index, lambda in aws_lambda_function.lambda_function:
      index => lambda
  }
  name = "/aws/lambda/${each.value.function_name}" 
  retention_in_days = 1
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name = "${var.prefix}-lambda_logging"
  path = "/"
  description = "Iam policy for logging to lambda"
  policy = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "name" {
  role = aws_iam_role.lambda_function.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
