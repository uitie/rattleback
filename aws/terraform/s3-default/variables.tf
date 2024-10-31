variable "test_prefix" {
  type        = string
  description = "A prefix what is appended on the front of every object created by this test case."
  default     = ""
}

variable "region" {
  type        = string
  description = "The region in which to put all test objects"
  default     = "us-east-1"
}

variable "bad_bucket_acl" {
  type        = string
  description = "Depending on policy settings this might have to be updated in order to apply."
  default     = "public-read-write"
}
