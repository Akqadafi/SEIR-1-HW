resource "google_compute_health_check" "hc01" {
  name = "http-health-check"

  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 1
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}