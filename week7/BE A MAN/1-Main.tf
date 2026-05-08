resource "google_storage_bucket" "gcplab" {
  name = "gcplab-site"
  storage_class = "STANDARD"
  location      = "US-CENTRAL1"
  force_destroy = true
  uniform_bucket_level_access = true
  
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_object" "index" {
  name         = "index.html"
  bucket       = google_storage_bucket.gcplab.name
  source       = "index.html"
}

resource "google_storage_bucket_object" "error" {
  name         = "404.html"
  bucket       = google_storage_bucket.gcplab.name
  source       = "404.html"
}

resource "google_storage_bucket_object" "css" {
  name         = "style.css"
  bucket       = google_storage_bucket.gcplab.name
  source       = "style.css"
}

resource "google_storage_bucket_object" "image" {
  name         = "Cybpunk Room.jpg"
  bucket       = google_storage_bucket.gcplab.name
  source       = "Cybpunk Room.jpg"
}