variable "bucket_name" {
  type        = string
  description = "The name of the bucket.  It has to be globally unique."
}

variable "bucket_location" {
  type        = string
  description = "The location of the bucket.  Can be Multi-region, or Regional"
  default     = "US"
}

variable "gcp_project" {
  type        = string
  description = "The GCP project to put the bucket into"
}
