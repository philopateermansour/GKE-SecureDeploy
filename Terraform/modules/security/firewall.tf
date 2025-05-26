resource "google_compute_firewall" "allow_ssh_to_management" {
  name    = "allow-ssh"
  network = var.vpc_name
  source_ranges = ["35.235.240.0/20"]
  direction          = "INGRESS"
  target_tags        = ["allow-ssh"]
  priority           = 1000
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}


resource "google_compute_firewall" "allow_artifact_egress" {
  name               = "enable-artifact-egress"
  network            = var.vpc_name
  direction          = "EGRESS"
  priority           = 900         
  destination_ranges = ["199.36.153.8/30",
                        "199.36.153.4/30",
                        "199.36.153.0/30"]
  target_tags        = ["allow-artifact"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "allow_gke_control_plane_egress" {
  name               = "allow-gke-control-plane-egress"
  network            = var.vpc_name
  direction          = "EGRESS"
  priority           = 850 
  target_tags        = ["allow-gke-control-plane"] 

  destination_ranges = ["172.16.0.0/28"]

  allow {
    protocol = "tcp"
    ports    = ["443"] 
  }
  allow {
    protocol = "icmp" 
  }
}

resource "google_compute_firewall" "allow_google_api_egress" {
  name               = "allow-google-api-egress"
  network            = var.vpc_name
  direction          = "EGRESS"
  priority           = 800 
  target_tags        = ["allow-google-api"] 

 
  destination_ranges = [
    "199.36.153.4/30",  
    "199.36.153.0/30",  
    "169.254.169.254",
  ]

  allow {
    protocol = "tcp"
    ports    = ["443", "80"] 
  }
  allow {
    protocol = "udp" 
  }
  allow {
    protocol = "icmp"
  }
}