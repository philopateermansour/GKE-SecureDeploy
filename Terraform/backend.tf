
terraform {
  backend "gcs" {
    bucket  = "philopater-tf-state-bucket-2"
    prefix  = "terraform/state"
  }
}
