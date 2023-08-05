terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.4.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

provider "rke" {
  log_file = "rke_debug.log"
}