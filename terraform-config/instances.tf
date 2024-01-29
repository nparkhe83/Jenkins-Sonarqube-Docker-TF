resource "google_compute_instance_from_template" "jenkins" {
  name                     = var.jenkins_instance_name
  zone                     = "${var.region}-a"
  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags = ["${var.jenkins_network_tag}"]
  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.jenkins_script.bucket}/${google_storage_bucket_object.jenkins_script.name}"
  }
}

resource "google_compute_instance_from_template" "sonarqube" {
  name                     = var.sonarqube_instance_name
  zone                     = "${var.region}-a"
  source_instance_template = google_compute_instance_template.jsd_sonar_template.self_link_unique

  tags = ["${var.sonarqube_network_tag}"]
  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.sonarqube_script.bucket}/${google_storage_bucket_object.sonarqube_script.name}"
  }
}

resource "google_compute_instance_from_template" "docker" {
  name                     = var.docker_instance_name
  zone                     = "${var.region}-a"
  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags = ["${var.docker_network_tag}"]
  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.docker_script.bucket}/${google_storage_bucket_object.docker_script.name}"
  }
}
