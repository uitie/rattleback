variable "gcp_project" {
  type        = string
  description = "The GCP project to put the bucket into"
}

variable "name" {
  type        = string
  description = "The name of the managed zone"
  default     = "uut"
}

variable "domain" {
  type        = string
  description = "If provided this is the domain to use.  Otherwise a random domain is generated"
  default     = ""
}
