resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.management.region
  network = google_compute_network.my_vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}