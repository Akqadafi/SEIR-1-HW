#Go to:
#VPC Network → Subnets
#Confirm:

#    subnet exists
#    secondary ranges visible



resource "google_compute_subnetwork" "fortress" {
  name                     = "fortress-subnet"
  ip_cidr_range            = "10.1.0.0/23"
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  # IMPORTANT:
  # These CIDR ranges MUST NOT overlap
  # Do not modify unless you understand subnetting

  secondary_ip_range {
    range_name    = "new-york"
    ip_cidr_range = "10.1.48.0/24"
  }

  secondary_ip_range {
    range_name    = "boston"
    ip_cidr_range = "10.1.52.0/24"
  }

  depends_on = [
    google_compute_network.main
  ]
}
