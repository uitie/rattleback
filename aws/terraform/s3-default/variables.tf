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

variable "uut_bucket_acl" {
  type        = string
  description = "Allows the changing of the ACLs."
  default     = "public-read-write"
}
