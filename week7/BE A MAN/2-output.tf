output "bucket_name" {
  description = "Name of the GCS bucket used for the static website."
  value       = google_storage_bucket.gcplab.name
}

output "index_url" {
  description = "Clickable URL for the static website index page."
  value       = "https://storage.googleapis.com/${google_storage_bucket.gcplab.name}/index.html"
}