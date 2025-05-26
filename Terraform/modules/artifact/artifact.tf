resource "google_artifact_registry_repository" "philopater-repo" {
  location      = "us"
  repository_id = "philopater-repository"
  format        = "DOCKER"
}