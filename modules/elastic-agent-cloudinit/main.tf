# Reusable Elastic Agent cloud-init installer module
# Generates vendor-data cloud-config snippet on target Proxmox node.

variable "node_name" {
  type        = string
  description = "Proxmox node name to upload snippet to"
}

variable "datastore_id" {
  type        = string
  description = "Datastore ID where snippets are stored"
  default     = "datapool0"
}

variable "elastic_version" {
  type        = string
  description = "Version of Elastic Agent to install"
  default     = "8.14.3"
}

variable "filename" {
  type        = string
  description = "Filename for snippet in Proxmox"
  default     = "elastic-agent-installer.yaml"
}

resource "proxmox_virtual_environment_file" "elastic_agent_cloud_config" {
  node_name    = var.node_name
  datastore_id = var.datastore_id
  content_type = "snippets"

  source_raw {
    data      = <<-EOF
#cloud-config
runcmd:
  - |
    set -e
    mkdir -p /opt/elastic-install && cd /opt/elastic-install
    if [ -f /etc/debian_version ]; then
      curl -sSL -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${var.elastic_version}-amd64.deb
      dpkg -i elastic-agent-${var.elastic_version}-amd64.deb
    elif [ -f /etc/redhat-release ]; then
      curl -sSL -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${var.elastic_version}-x86_64.rpm
      rpm -vi elastic-agent-${var.elastic_version}-x86_64.rpm
    else
      curl -sSL -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${var.elastic_version}-linux-x86_64.tar.gz
      tar xzvf elastic-agent-${var.elastic_version}-linux-x86_64.tar.gz
      cd elastic-agent-${var.elastic_version}-linux-x86_64
      sudo ./elastic-agent install --non-interactive || true
    fi
EOF
    file_name = var.filename
  }
}

output "snippet_file_id" {
  description = "The Proxmox file ID for cloud-init vendor-data snippet"
  value       = proxmox_virtual_environment_file.elastic_agent_cloud_config.id
}
