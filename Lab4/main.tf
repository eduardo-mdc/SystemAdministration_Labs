provider "google" {
  credentials = file(var.key)
  project     = var.project
  region      = var.key
  zone        = var.zone
}

# -- Resources --

# Virtual Network with custom subnet
resource "google_compute_network" "vpc_network" {
  name                    = "information-system-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "information-system-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "172.16.0.0/16"
  region        = var.region
}


# Static IP address reservation for VMs
resource "google_compute_address" "vm_static_ip" {
  count = 4
  name  = "vm-${count.index+11}-ip"
  region = var.region
}


resource "google_compute_firewall" "allow_icmp_ssh" {
  name    = "allow-icmp-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow from any IP, modify as needed for security
}


# Virtual Machine Instances with Static IP
resource "google_compute_instance" "debian-vault" {
  name         = "debian-vault"
  machine_type = "e2-micro"
  tags         = ["information-system", "vm", "vault"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-10-buster-v20231115"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    network_ip = "172.16.0.11"
    access_config {
      // Ephemeral public IP assigned for NAT
    }
  }
}

resource "google_compute_instance" "centos-workstation" {
  name         = "centos-workstation"
  machine_type = "e2-micro"
  tags         = ["information-system", "vm", "workstation"]

  boot_disk {
    initialize_params {
      image = "projects/centos-cloud/global/images/centos-stream-8-v20231115"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    network_ip = "172.16.0.12"
    access_config {
      // Ephemeral public IP assigned for NAT
    }
  }
}


resource "google_compute_instance" "fedora-server-ldap" {
  name         = "fedora-server-ldap"
  machine_type = "e2-micro"
  tags         = ["information-system", "vm", "ldap"]

  boot_disk {
    initialize_params {
      image = "projects/fedora-cloud/global/images/fedora-cloud-base-gcp-38-1-6-x86-64"
    }
  }

   network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    network_ip = "172.16.0.13"
    access_config {
      // Ephemeral public IP assigned for NAT
    }
  }
}


resource "google_compute_instance" "windows-datacenter-workstation" {
  name         = "windows-datacenter-workstation"
  machine_type = "e2-medium"
  tags         = ["information-system", "vm", "workstation"]

  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2019-dc-v20231115"
      size  = 50
    }
  }

   network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    network_ip = "172.16.0.14"
     access_config {
      // Ephemeral public IP assigned for NAT
    }
  }
}


