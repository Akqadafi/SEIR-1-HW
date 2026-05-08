
resource "google_compute_network" "vpc_network" {
  name                    = "theou-gcp-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "local_file" "favorite_food" {
  content  = "Pizza is my favorite food.\n"
  filename = "${path.module}/favorite_food.txt"
}