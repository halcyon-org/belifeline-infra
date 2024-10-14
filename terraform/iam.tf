resource "google_iam_workload_identity_pool" "github_actions_pool" {
  provider                  = google-beta
  project                   = local.project_id
  workload_identity_pool_id = "github-oidc-pool"
  display_name              = "github-oidc-pool"
  description               = "Use from GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  provider                           = google-beta
  project                            = local.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "github-actions"
  description                        = "Use from GitHub Actions"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

data "google_service_account" "terraform_sa" {
  account_id = local.terraform_sa
}

resource "google_service_account_iam_member" "terraform_sa_workload_identity_user" {
  service_account_id = data.google_service_account.terraform_sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions_pool.name}/attribute.repository/${local.repo_name}"
}

# resource "google_project_iam_member" "terraform_sa_run_admin" {
#   project = local.project_id
#   role    = "roles/run.admin"
#   member  = "serviceAccount:${data.google_service_account.terraform_sa.email}"
# }

# resource "google_project_iam_member" "terraform_sa_run_invoker" {
#   project = local.project_id
#   role    = "roles/run.invoker"
#   member  = "serviceAccount:${data.google_service_account.terraform_sa.email}"
# }

resource "google_project_iam_member" "shiron_iam_admin" {
  project = local.project_id
  role    = "roles/iam.securityAdmin"
  member  = "user:${local.shiron_email}"
}
