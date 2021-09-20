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
            image = "debian-cloud/debian-9"
        }
    }

    network_interface {
        network = google_compute_network.vpc.self_link
        access_config { }
    }

    metadata_startup_script = "wget https://apt.puppet.com/puppet7-release-stretch.deb; sudo dpkg -i puppet7-release-stretch.deb; sudo apt update; sudo apt install puppetserver git -y; sudo systemctl start puppetserver; sudo apt install puppet-agent -y; sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true; puppet module install computology-packagecloud --version 0.3.2; git clone https://github.com/nkalupahana/rundeck.git; cd rundeck; sudo /opt/puppetlabs/bin/puppet apply config.pp"
}

# Allow HTTP & HTTPS
resource "google_compute_firewall" "allow-rundeck-http" {
    name = "${var.app_name}-fw-allow-http"
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