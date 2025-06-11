provider "aws" {
  region = "us-east-2"
}
data "aws_region" "current" {}
resource "aws_dynamodb_table" "test_table_a" {
  deletion_protection_enabled = true
  billing_mode                = "PAY_PER_REQUEST"
  tags                        = "null"
  server_side_encryption {
    enabled = false
  }
}
resource "aws_lambda_function" "myfunction" {
  tracing_config {
    mode = "Active"
  }
}
resource "aws_appsync_graphql_api" "test_api" {
  authentication_type = "API_KEY"
  xray_enabled        = true
}
resource "aws_keyspaces_table" "mykeyspacestable" {
  encryption_specification {
    type = "AWS_OWNED_KMS_KEY"
  }
}