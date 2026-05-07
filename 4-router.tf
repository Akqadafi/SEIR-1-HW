#thisis for VPC main

resource "google_compute_router" "router" {
  name    = "router"
  region  = "us-central1"
  network = google_compute_network.main.id

  bgp {
    asn = 64514
  }

  depends_on = [
    google_compute_network.main
  ]
}

# For Dr. Who's VPC, the router is named "router" and is associated with the "dr-who" network. The ASN is set to 64514, which is a private ASN commonly used for internal routing. The router is created in the "us-central1" region and depends on the existence of the "dr-who" network.

resource "google_compute_router" "d-router" {
  name    = "d-router"
  region  = "us-central1"
  network = google_compute_network.dr-who.id

  bgp {
    asn = 65520
  }

  depends_on = [
    google_compute_network.dr-who
  ]
}
