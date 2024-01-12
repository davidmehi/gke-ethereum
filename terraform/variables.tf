variable "project" {
  description = "GCP project"
  type        = string
  default     = "gcda-dev"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone suffix"
  type        = string
  default     = "a"
}

variable "workspace_name_override" {
  type        = string
  default     = ""
}

variable "k8s_api_sources" {
  description = "List of CIDR subnets which can access the Kubernetes API endpoint"
  default     = ["0.0.0.0/0"]
}

variable "cluster_ipv4_cidr_block" {
  description = "The IP address range of the container pods in this cluster, in CIDR notation. See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#cluster_ipv4_cidr_block"
  default     = ""
}


variable "eth_holesky_consensus_instance_type" {
  description = "Instance type used for Eth holesky consensus"
  default     = "e2-standard-16"
}

variable "eth_holesky_consensus_instance_disk_size_gb" {
  description = "disk size for Eth holesky consensus"
  default     = "20"
}

variable "eth_holesky_validator_instance_type" {
  description = "Instance type used for Eth holesky validator"
  default     = "n2d-standard-4"
}

variable "eth_holesky_validator_instance_disk_size_gb" {
  description = "disk size for Eth holesky validator"
  default     = "20"
}

variable "eth_holesky_validator_cluster" {
  description = "Cluster name"
  type        = string
  default     = "eth-holesky-validator-cluster"  
}
