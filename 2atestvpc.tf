# STAGE 2: VPC FOUNDATION
# Goal:
# - Enable required APIs
# - Create custom VPC
#
# Verify:
# - Compute API enabled
# - VPC named "main" exists
#
# Screenshot required:
# - API page
# - VPC Networks page


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "robo" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "tardis" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "dr-who" {
  name                            = "dr-who"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.robo,
    google_project_service.tardis
  ]
}

resource "google_compute_subnetwork" "earth" {
  name                     = "earth-subnet"
  ip_cidr_range            = "10.254.0.0/23"
  region                   = "us-central1"
  network                  = google_compute_network.dr-who.id
  private_ip_google_access = true

  # IMPORTANT:
  # These CIDR ranges MUST NOT overlap
  # Do not modify unless you understand subnetting

  secondary_ip_range {
    range_name    = "chicago"
    ip_cidr_range = "10.254.69.0/24"
  }

  secondary_ip_range {
    range_name    = "san-francisco"
    ip_cidr_range = "10.254.169.0/24"
  }

  depends_on = [
    google_compute_network.dr-who
  ]
}
