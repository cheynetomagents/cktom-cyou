variable "hostname" {
  description = "Netdata hostname reported by this agent (defaults to Proxmox VM name)."
  type        = string
}

variable "ssh_host" {
  description = "SSH-reachable address for this VM (used to push config, idempotent installer, restart-on-change only)."
  type        = string
}

variable "ssh_user" {
  description = "SSH user with sudo/root on the target VM."
  type        = string
  default     = "root"
}

variable "install_mode" {
  description = "How Netdata is deployed on this host: \"native\" (host package via kickstart installer) or \"container\" (podman quadlet)."
  type        = string
  validation {
    condition     = contains(["native", "container"], var.install_mode)
    error_message = "install_mode must be \"native\" or \"container\"."
  }
}

variable "is_parent" {
  description = "If true, this agent is configured to RECEIVE streams (Netdata streaming parent) instead of sending."
  type        = bool
  default     = false
}

variable "stream_parent_host" {
  description = "Hostname/IP of the streaming parent (required for children, ignored for parents)."
  type        = string
  default     = null
}

variable "stream_parent_port" {
  description = "Port the streaming parent listens on."
  type        = number
  default     = 19999
}

variable "stream_api_key" {
  description = "Shared Netdata streaming API key (UUID). Same key must be present in parent's [API_KEY] stanza and every child's [stream] stanza. Source from sops-encrypted tfvars — never plaintext in repo."
  type        = string
  sensitive   = true
}

variable "collectors" {
  description = "Application Prometheus/OpenTelemetry (Prometheus-exposition) scrape targets co-located on this host, rendered into the agent's go.d/prometheus.conf."
  type = list(object({
    job_name     = string
    url          = string
    update_every = optional(number, 10)
  }))
  default = []
}

variable "container_network" {
  description = "Podman network the netdata quadlet container joins (container install_mode only)."
  type        = string
  default     = "internal"
}
