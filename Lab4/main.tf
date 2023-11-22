provider "google" {
  credentials = file(var.key)
  project     = var.project
  region      = var.key
  zone        = var.zone
}

# -- Resources --

# Virtual Network
resource "google_compute_network" "vpc_network" {
  name = "information-system-network"
}

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
    network = google_compute_network.vpc_network.name
    access_config {
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
    network = google_compute_network.vpc_network.name
    access_config {
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
    network = google_compute_network.vpc_network.name
    access_config {
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
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}


