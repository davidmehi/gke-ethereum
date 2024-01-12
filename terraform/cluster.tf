resource "google_container_cluster" "eth_holesky_validator_cluster" {
  provider = google-beta
  name     = var.eth_holesky_validator_cluster
  location = local.zone
  network  = google_compute_network.eth_holesky.id

  remove_default_node_pool = true
  initial_node_count       = 1
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"

  release_channel {
    channel = "REGULAR"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.k8s_api_sources
      content {
        cidr_block = cidr_blocks.value
      }
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.1.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.cluster_ipv4_cidr_block
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  pod_security_policy_config {
    enabled = false
  }

}


resource "google_container_node_pool" "consensus-pool" {
  provider = google-beta
  name     = "consensus-pool"
  location = local.zone
  cluster  = google_container_cluster.eth_holesky_validator_cluster.name
  # If cluster autoscaling is enabled, node_count should not be set
  # If node auto-provisioning is enabled, node_count should be set to 0 as this nodepool is most likely ignored
  node_count = 1

  node_config {
    machine_type    = var.eth_holesky_consensus_instance_type
    image_type      = "COS_CONTAINERD"
    disk_size_gb    = var.eth_holesky_consensus_instance_disk_size_gb
    service_account = google_service_account.gke.email
    tags            = ["consensus"]
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    shielded_instance_config {
      enable_secure_boot = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

  }

}


resource "google_container_node_pool" "validator-pool" {
  provider = google-beta
  name     = "validator-pool"
  location = local.zone
  cluster  = google_container_cluster.eth_holesky_validator_cluster.name
  # If cluster autoscaling is enabled, node_count should not be set
  # If node auto-provisioning is enabled, node_count should be set to 0 as this nodepool is most likely ignored
  node_count = 1

  node_config {
    machine_type    = var.eth_holesky_validator_instance_type
    image_type      = "COS_CONTAINERD"
    disk_size_gb    = var.eth_holesky_validator_instance_disk_size_gb
    service_account = google_service_account.gke.email
    tags            = ["validator"]
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    shielded_instance_config {
      enable_secure_boot = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

  }

}