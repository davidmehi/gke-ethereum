terraform {
  backend "gcs" {
    bucket = "gcda-dev-eth-holesky-tf" # bucket name created in step 2
    prefix = "state/validator"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

data "google_client_config" "provider" {}

locals {
  zone           = "${var.region}-${var.zone}"
  workspace_name = var.workspace_name_override == "" ? terraform.workspace : var.workspace_name_override
}

resource "google_project_service" "services" {
  for_each = {
    "clouderrorreporting.googleapis.com"  = true
    "cloudresourcemanager.googleapis.com" = true
    "compute.googleapis.com"              = true
    "container.googleapis.com"            = true
    "iam.googleapis.com"                  = true
    "logging.googleapis.com"              = true
    "monitoring.googleapis.com"           = true
    "secretmanager.googleapis.com"        = true
  }
  service            = each.key
  disable_on_destroy = false
}