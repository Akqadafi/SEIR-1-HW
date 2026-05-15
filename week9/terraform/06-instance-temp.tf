resource  "google_compute_instance_template" "Instance_Template01" {
  name         = "Week9-Instance-Template"
  machine_type = "e2-medium"

  disk {
    source_image = data.google_compute_image.centos_stream_10.self_link
    disk_size_gb = 100
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.fortress.id
    
    access_config {
        network_tier = "PREMIUM"
    }
  }

metadata_startup_script = file("${path.module}/startup.sh")

  tags = ["http-server"]
}

resource "google_compute_instance_group_manager" "instance_group_manager01" {
  name               = "Week9-instance-group-manager"
  base_instance_name = "instance-group-manager"
  target_size        = "3"
  zone               = var.zones[0]

  version {
    instance_template = google_compute_instance_template.Instance_Template01.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
    auto_healing_policies {
    health_check      = google_compute_health_check.hc01.id
    initial_delay_sec = 300
  }


}