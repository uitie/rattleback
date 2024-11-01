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

variable "disable_uut" {
  type        = bool
  description = "Disable the main UUT S3 bucket."
  default     = false
}

variable "disable_uut_with_deprecation" {
  type        = bool
  description = "Disable the S3 bucket that uses deprecated options."
  default     = false
}
