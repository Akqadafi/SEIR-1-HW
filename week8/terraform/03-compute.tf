resource "google_compute_instance" "vm_instance" {
    name         = "centos-stream-10-vm"
    machine_type = "n2-standard-4"
    zone           = var.zone

    boot_disk {
        initialize_params {
            image = data.google_compute_image.centos_stream_10.self_link
            size  = 100
            type  = "pd-ssd"
        }
    }

    network_interface {
        network       = "default"
        access_config {}
    }

    metadata_startup_script = file("${path.module}/startup.sh")

    tags = ["http-server"]
}
