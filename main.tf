terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocen"
            version = "~> 2.0"
        }
    }
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name = var.k8s_name
  region = var.region
  version = "1.22.8-do.1"

  node_pool {
    name        = "default"
    size        = "s-2vcpu-4gb"
    node_count  = 3
  }
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
    cluster_id = digitalocean_kubernetes_cluster.k8s-iniciativa-devops.id

    name        = "premium"
    size        = "s-4vcpu-8gb"
    node_count  = 2
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s-iniciativa-devops.endpoint
}

resource "local_file" "kube_config" {
  content = digitalocean_kubernetes_cluster.k8s-iniciativa-devops.kube_config.0.raw_config
  filename = "kube_config.yaml"
}

# Execução dos comandos no cmd no diretório IAC
# $ terraform init (inicializar o terraform e baixar os plugins necessários)
# $ terraform apply
# $ kube_config.yaml ~/.kube/config