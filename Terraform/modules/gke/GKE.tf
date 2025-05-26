resource "google_service_account" "gke_sa"  {
  account_id   = "gke-service-account-id"
  display_name = "Service Account for gke" 
}

resource "google_container_cluster" "philopater-gke-cluster" {
  name     = var.cluster_name
  location = var.cluster_location
  network = var.vpc_name
  subnetwork = var.restricted_subnet_id
  deletion_protection = false
  

  
  master_authorized_networks_config {

    cidr_blocks {
      cidr_block   = "102.45.140.55/32"
      display_name = "My IP"
    }
    cidr_blocks {
      cidr_block   = var.management_cidr
      display_name = "My IP"
    }
  } 

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
}



  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "philopater_preemptible_nodes" {
  name       = var.node_pool_name
  location   = var.cluster_location
  cluster    = google_container_cluster.philopater-gke-cluster.name
  node_count = 2

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    disk_size_gb = 20
    tags = ["deny-egress","allow-artifact","allow-gke-control-plane","allow-ssh","allow-google-api"]

    service_account = google_service_account.gke_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_project_iam_member" "gke_sa_permissions" {
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/artifactregistry.reader",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",

  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}