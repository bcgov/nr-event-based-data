locals {
  is_dev                  = !contains(["production", "tools", "test"], var.environment)
  environment_fs          = local.is_dev ? "permitting-${var.environment}" : "permitting"
  resource_environment_fs = local.is_dev ? "permitting-%s-${var.environment}" : "permitting"
}

# Shared data
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eventbridge_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

# Lambda builds
data "archive_file" "api_permits_get" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/permits/get/handler.py"
  output_path = "${path.module}/builds/api_permits_get.zip"
}

data "archive_file" "api_permits_post" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/permits/post/handler.py"
  output_path = "${path.module}/builds/api_permits_post.zip"
}

data "archive_file" "api_statuses_get_all" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/statuses/get_all/handler.py"
  output_path = "${path.module}/builds/api_statuses_get_all.zip"
}

data "archive_file" "write_to_data_lake" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/write_to_data_lake/handler.py"
  output_path = "${path.module}/builds/write_to_data_lake.zip"
}

data "archive_file" "write_to_dynamo" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/write_to_dynamo/handler.py"
  output_path = "${path.module}/builds/write_to_dynamo.zip"
}

data "archive_file" "dynamo_cdc_processor" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/dynamo_cdc_processor/handler.py"
  output_path = "${path.module}/builds/dynamo_cdc_processor.zip"
}
