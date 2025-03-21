resource "google_storage_bucket" "uut" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true
}
resource "google_storage_bucket_iam_member" "uut" {
  bucket = google_storage_bucket.uut.name
  role = var.role
  member = "allUsers"
}
