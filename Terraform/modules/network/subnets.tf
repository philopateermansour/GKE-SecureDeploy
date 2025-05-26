resource "google_compute_subnetwork" "management" {
  name          = "management-subnetwork"
  ip_cidr_range = "10.23.1.0/24"
  region        = var.region
  network       = google_compute_network.my_vpc.id
}
resource "google_compute_subnetwork" "restricted" {
  name          = "restricted-subnetwork"
  ip_cidr_range = "10.23.2.0/24"
  region        = var.region
  network       = google_compute_network.my_vpc.id 
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.24.0.0/16"
  }
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.25.0.0/20"
  }
  
}
  