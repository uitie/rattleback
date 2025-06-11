data "aws_caller_identity" "user" {}

locals {
  test_case = "s3-default"

  prefix = "${var.test_prefix}${data.aws_caller_identity.user.account_id}-${local.test_case}"

  tags = {
    test = local.test_case
  }

  # if the acl is set to anything public then we need to enable the public
  # block
  public = length(regexall("public", var.uut_bucket_acl)) > 0
}

# This bucket should be flagged.  As of the 3.x version of this provider
# Buckets are default private with explicit file ownership meaning the `acl`
# setting throws an error now.  In order to make
# a bucket public we have to adjust ownership via separate objects.
resource "aws_s3_bucket" "uut" {
  bucket = "${local.prefix}-uut"

  force_destroy = true
}
resource "aws_s3_bucket_ownership_controls" "uut" {
  bucket = aws_s3_bucket.uut.id

  rule {
    # This is needed for the ACLs to be valid
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "uut" {
  bucket = aws_s3_bucket.uut.id

  block_public_acls       = !local.public
  block_public_policy     = !local.public
  ignore_public_acls      = !local.public
  restrict_public_buckets = !local.public
}

# The ACL needs to be set in an object to ensure the access block and ownership
# controls are set first.
resource "aws_s3_bucket_acl" "uut" {
  bucket = aws_s3_bucket.uut.id

  acl = var.uut_bucket_acl

  depends_on = [
    aws_s3_bucket_ownership_controls.uut,
    aws_s3_bucket_public_access_block.uut,
  ]
}


# Edit to trigger scan
resource "aws_s3_object" "uut" {
  bucket = aws_s3_bucket.uut.id

  key    = "helloworld"
  source = "files/test.txt"
}
