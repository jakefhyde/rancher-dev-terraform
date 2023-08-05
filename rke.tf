variable "roles" {
  type    = list(string)
  default = ["controlplane", "worker", "etcd"]
}

locals {
  # [1, 1, 1] or [3, 2, 3]
  totals_per     = [for i in var.instances : i.total]
  # [1, 2, 3] or [3, 5, 8]
  start_index    = [for i, v in local.totals_per : (i == 0 ? 0 : sum(slice(local.totals_per, 0, i)))]
  # [[{}], [{}], [{}]
  nodes_per_pool = [for i, v in local.start_index : slice(aws_instance.server, v, v + local.totals_per[i])]
  # same structure as above
  nodes          = [
    for i, v in local.nodes_per_pool :[for j, w in v : { address = w.public_ip, role = var.instances[i].roles }]
  ]
  # [{},{},{}]
  flattened_nodes = flatten(local.nodes)
}

resource rke_cluster "cluster" {
  depends_on         = [aws_instance.server]
  enable_cri_dockerd = true
  dynamic "nodes" {
    for_each = local.flattened_nodes
    content {
      user    = var.ssh_user
      address = nodes.value["address"]
      role    = nodes.value["role"]
      ssh_key = tls_private_key.global_key.private_key_pem
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}