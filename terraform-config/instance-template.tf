resource "google_compute_instance_template" "jsd_instance_template" {
  provider = google-beta

  name         = var.instance_template_name
  machine_type = "n1-standard-1"

  scheduling {
    automatic_restart           = false
    on_host_maintenance         = "TERMINATE"
    provisioning_model          = "SPOT"
    instance_termination_action = "DELETE"
    preemptible                 = true
    max_run_duration {
      seconds = 7200
    }
  }

  // Create a new boot disk from an image
  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230918"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-balanced"
    disk_size_gb = 10
  }

  shielded_instance_config {
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.jsd_subnetwork.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
  metadata = {
    serial_port_logging_enable = "TRUE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  region = var.region
}

resource "google_compute_instance_template" "jsd_sonar_template" {
  provider = google-beta

  name         = var.sonar_template_name
  machine_type = "custom-1-5120"

  scheduling {
    automatic_restart           = false
    on_host_maintenance         = "TERMINATE"
    provisioning_model          = "SPOT"
    instance_termination_action = "DELETE"
    preemptible                 = true
    max_run_duration {
      seconds = 7200
    }
  }

  // Create a new boot disk from an image
  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230918"
    auto_delete  = true
    boot         = true
    disk_type    = "pd-balanced"
    disk_size_gb = 10
  }

  shielded_instance_config {
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.jsd_subnetwork.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
  metadata = {
    serial_port_logging_enable = "TRUE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  region = var.region
}

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_project_iam_member" "storage_iam_binding" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.default.email}"
}
