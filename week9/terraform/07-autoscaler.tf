resource "google_compute_autoscaler" "autoscale00" {
  name   = "autoscale00"
  zone = var.region
  target = google_compute_instance_group_manager.instance_group_manager01.id

  autoscaling_policy {
    min_replicas    = 2
    max_replicas    = 10
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}