provider "google" {
  project = "automation-nk"
  region  = "us-central1"
  zone    = "us-central1-c"
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.app_name}-net"
  auto_create_subnetworks = "true"
}

# Create VM (with VPC)
resource "google_compute_instance" "vm" {
    name         = var.app_name
    machine_type = "e2-medium"

    boot_disk {
        initialize_params {
            image = "ubuntu-1604-xenial-v20210429"
        }
    }

    network_interface {
        network = google_compute_network.vpc.self_link
        access_config { }
    }

    allow_stopping_for_update = true

    metadata_startup_script = file("${path.module}/setup-puppet.sh")
}

# Allow HTTP & HTTPS
resource "google_compute_firewall" "allow-rundeck-http" {
    name = "${var.app_name}-allow-rundeck"
    network = "${google_compute_network.vpc.name}"
    allow {
        protocol = "tcp"
        ports    = ["4440"]
    }
}

resource "google_compute_firewall" "allow-ingress-from-iap" {
    name = "${var.app_name}-fw-allow-iap-ingress"
    network = "${google_compute_network.vpc.name}"
    source_ranges = ["35.235.240.0/20"]
    allow {
        protocol = "tcp"
        ports    = ["22", "3389"]
    }
}