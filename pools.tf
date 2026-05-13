# ──────────────────────────────────────────────
# Resource Pools (from node3 cluster)
# ──────────────────────────────────────────────

resource "proxmox_virtual_environment_pool" "security_onion" {
  provider = proxmox.node3
  pool_id  = "SecurityOnion"
}

resource "proxmox_virtual_environment_pool" "mosse" {
  provider = proxmox.node3
  pool_id  = "mosse"
}

resource "proxmox_virtual_environment_pool" "talos" {
  provider = proxmox.node3
  pool_id  = "talos"
}
