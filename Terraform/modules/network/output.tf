output "management_subnet_id" {
  value = google_compute_subnetwork.management.id
}
output "vpc_name" {
  value = google_compute_network.my_vpc.name
}
output "management_cidr" {
  value = google_compute_subnetwork.management.ip_cidr_range
}
output "restricted_subnet_id" {
  value = google_compute_subnetwork.restricted.id
}
output "restricted_cidr" {
  value = google_compute_subnetwork.restricted.ip_cidr_range
}