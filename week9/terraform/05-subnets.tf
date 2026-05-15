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
  
}
