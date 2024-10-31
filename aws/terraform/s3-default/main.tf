data "aws_caller_identity" "user" {}

locals {
  prefix = "${var.test_prefix}${data.aws_caller_identity.user.account_id}-s3-default"

  tags = {
    test = "s3-default"
  }
}

# This bucket should be flagged.  As of the 3.x version of this provider
# Buckets are default private with explicit file ownership meaning the `acl`
# setting throws an error now.  In order to make
# a bucket public we have to adjust ownership via separate objects.
resource "aws_s3_bucket" "bad" {
  bucket = "${local.prefix}-bad"

  acl = var.bad_bucket_acl

  force_destroy = true
}
resource "aws_s3_bucket_ownership_controls" "bad" {
  bucket = aws_s3_bucket.bad.id

  rule {
    # This is needed for the ACLs to be valid
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_object" "bad" {
  bucket = aws_s3_bucket.bad.id

  key    = "helloworld"
  source = "files/test.txt"
}

# This is a good bucket that is properly private, versioned, logged, encyrpted,
# and inventoried.
resource "aws_s3_bucket" "good-with-deprecation" {
  bucket = "${local.prefix}-good-with-deprecation"

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
    target_prefix = "good-with-deprecation/"
  }

  tags = local.tags
}

resource "aws_s3_bucket_object" "good-with-deprecation" {
  bucket = aws_s3_bucket.good-with-deprecation.id

  key    = "helloworld"
  source = "files/test.txt"
}

resource "aws_s3_bucket" "good" {
  bucket = "${local.prefix}-good"

  force_destroy = true

  // this doesn't use the acl, logging, encyrption, or logging blocks as those
  // are now separate objects.

  tags = local.tags
}
resource "aws_s3_bucket_ownership_controls" "good" {
  bucket = aws_s3_bucket.good.id

  rule {
    # This is needed for the ACLs to be valid
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "good" {
  bucket = aws_s3_bucket.good.id

  acl = "private"

  depends_on = [aws_s3_bucket_ownership_controls.good]
}
resource "aws_s3_bucket_versioning" "good" {
  bucket = aws_s3_bucket.good.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "good" {
  bucket = aws_s3_bucket.good.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}
resource "aws_s3_bucket_logging" "good" {
  bucket = aws_s3_bucket.good.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "good/"
}

resource "aws_s3_bucket_object" "good" {
  bucket = aws_s3_bucket.good.id

  key    = "helloworld"
  source = "files/test.txt"
}

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

  depends_on = [aws_s3_bucket_ownership_controls.good]
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

# This is the encryption key for the objects.
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
