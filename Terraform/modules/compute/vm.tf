resource "google_service_account" "management-service-account" {
  account_id   = "gke-management-service-account"
  display_name = "gke-management-service-account"
}

resource "google_project_iam_member" "gke_viewer" {
  for_each = toset(["roles/container.developer",
    "roles/container.clusterViewer",
    "roles/artifactregistry.admin",
    #"roles/artifactregistry.reader",
  ])

  role    = each.key
  project = var.project_id
  member  = "serviceAccount:${google_service_account.management-service-account.email}"
}
resource "google_compute_instance" "private_vm" {
  name         = "private-instance"
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true  

  service_account {
    email = google_service_account.management-service-account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["allow-ssh"]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.management_subnet_id
  }
}
