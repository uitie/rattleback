data "aws_caller_identity" "user" {}

locals {
  test_case = "s3-exemplar"

  prefix = "${var.test_prefix}${data.aws_caller_identity.user.account_id}-${local.test_case}"

  tags = {
    test = local.test_case
  }
}

################################## UUT ########################################
resource "aws_s3_bucket" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = "${local.prefix}-uut"

  force_destroy = true

  // this doesn't use the acl, logging, encyrption, or logging blocks as those
  // are now separate objects.

  tags = local.tags
}
resource "aws_s3_bucket_ownership_controls" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = aws_s3_bucket.uut[0].id

  rule {
    # This is needed for the ACLs to be valid
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = aws_s3_bucket.uut[0].id

  acl = "private"

  depends_on = [aws_s3_bucket_ownership_controls.uut]
}
resource "aws_s3_bucket_versioning" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = aws_s3_bucket.uut[0].id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = aws_s3_bucket.uut[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}
resource "aws_s3_bucket_logging" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = aws_s3_bucket.uut[0].id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "uut/"
}

resource "aws_s3_object" "uut" {
  count = var.disable_uut ? 0 : 1

  bucket = aws_s3_bucket.uut[0].id

  key    = "helloworld"
  source = "files/test.txt"
}
###############################################################################

########################## UUT with Deprecations ##############################
# This is a good bucket that is properly private, versioned, logged, encyrpted,
# and inventoried, but it is done using deprecated configs
resource "aws_s3_bucket" "uut_with_deprecation" {
  count = var.disable_uut_with_deprecation ? 0 : 1

  bucket = "${local.prefix}-uut-with-deprecation"

  force_destroy = true

  acl = "private"

  // This is now deprecated and should be replaced with aws_s3_bucket_versioning
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_key.arn
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "uut-with-deprecation/"
  }

  tags = local.tags
}

resource "aws_s3_object" "uut_with_deprecation" {
  count = var.disable_uut_with_deprecation ? 0 : 1

  bucket = aws_s3_bucket.uut_with_deprecation[0].id

  key    = "helloworld"
  source = "files/test.txt"
}
###############################################################################

############################# Logging Bucket ##################################
# This bucket is the logging bucket, so shoulldn't be flagged for
# anything, but some tools will flag it for not having logging enabled
resource "aws_s3_bucket" "logs" {
  bucket = "${local.prefix}-logs"

  force_destroy = true

  tags = local.tags
}
resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    # This is needed for the ACLs to be valid
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "logs" {
  bucket = aws_s3_bucket.logs.id

  acl = "log-delivery-write"

  depends_on = [aws_s3_bucket_ownership_controls.logs]
}
resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}
###############################################################################

################################## KMS Keys ###################################
# This is the encryption key for the buckets.
# We aren't testing keys here, so this should be an exemplar
resource "aws_kms_key" "s3_key" {
  description = "${local.prefix}-s3-key"

  deletion_window_in_days = 7 # Min days we can set it to

  enable_key_rotation     = true
  rotation_period_in_days = 90 # min rotation period

  tags = local.tags
}
resource "aws_kms_alias" "s3_key" {
  name = "alias/${local.prefix}-s3-key"

  target_key_id = aws_kms_key.s3_key.id
}
###############################################################################
