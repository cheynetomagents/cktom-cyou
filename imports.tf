# ──────────────────────────────────────────────
# Import blocks for existing infrastructure
#
# Run `tofu plan` to preview, then `tofu apply`
# to import existing resources into state.
# Remove these blocks after successful import.
# ──────────────────────────────────────────────

# ── Network Bridges ──────────────────────────

import {
  provider = proxmox.node3
  to       = proxmox_network_linux_bridge.node3_vmbr0
  id       = "node3:vmbr0"
}

import {
  provider = proxmox.node3
  to       = proxmox_network_linux_bridge.node3_vmbr1
  id       = "node3:vmbr1"
}

import {
  provider = proxmox.node3
  to       = proxmox_network_linux_bridge.node3_vmbr2
  id       = "node3:vmbr2"
}

import {
  provider = proxmox.node4
  to       = proxmox_network_linux_bridge.node4_vmbr0
  id       = "node4:vmbr0"
}

# ── node4 VMs ────────────────────────────────

import {
  provider = proxmox.node4
  to       = proxmox_virtual_environment_vm.node4_fipa
  id       = "qemu/150"
}
