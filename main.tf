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
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc.self_link
    access_config {
    }
  }
}

# Allow HTTP & HTTPS
resource "google_compute_firewall" "allow-http" {
  name = "${var.app_name}-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

resource "google_compute_firewall" "allow-https" {
  name = "${var.app_name}-fw-allow-https"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}
