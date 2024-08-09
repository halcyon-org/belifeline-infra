resource "google_project_service" "project" {
  project = local.project_id
  service = "iamcredentials.googleapis.com"
}
