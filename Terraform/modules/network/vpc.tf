resource "google_compute_network" "my_vpc" {
  project                 = var.project
  name                    = "my-vpc"
  auto_create_subnetworks = false
}