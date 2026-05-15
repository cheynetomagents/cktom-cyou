# ──────────────────────────────────────────────
# Access Control for AI
# ──────────────────────────────────────────────

# -- node1 --

resource "proxmox_virtual_environment_role" "node1_ai_troubleshooter" {
  provider = proxmox.node1
  role_id  = "AITroubleshooter"

  privileges = [
    "VM.Audit",
    "VM.Monitor",
    "Datastore.Audit",
    "Sys.Audit",
    "Pool.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "node1_proxmin" {
  provider = proxmox.node1
  user_id  = "proxmin@pve"
  comment  = "User for AI context gathering and troubleshooting"

  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.node1_ai_troubleshooter.role_id
  }
}

# -- node3 --

resource "proxmox_virtual_environment_role" "node3_ai_troubleshooter" {
  provider = proxmox.node3
  role_id  = "AITroubleshooter"

  privileges = [
    "VM.Audit",
    "VM.Monitor",
    "Datastore.Audit",
    "Sys.Audit",
    "Pool.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "node3_proxmin" {
  provider = proxmox.node3
  user_id  = "proxmin@pve"
  comment  = "User for AI context gathering and troubleshooting"

  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.node3_ai_troubleshooter.role_id
  }
}

# -- node4 --

resource "proxmox_virtual_environment_role" "node4_ai_troubleshooter" {
  provider = proxmox.node4
  role_id  = "AITroubleshooter"

  privileges = [
    "VM.Audit",
    "VM.Monitor",
    "Datastore.Audit",
    "Sys.Audit",
    "Pool.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "node4_proxmin" {
  provider = proxmox.node4
  user_id  = "proxmin@pve"
  comment  = "User for AI context gathering and troubleshooting"

  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.node4_ai_troubleshooter.role_id
  }
}

# ── Import existing users ────────────────────

import {
  provider = proxmox.node1
  to       = proxmox_virtual_environment_user.node1_proxmin
  id       = "proxmin@pve"
}

import {
  provider = proxmox.node3
  to       = proxmox_virtual_environment_user.node3_proxmin
  id       = "proxmin@pve"
}

import {
  provider = proxmox.node4
  to       = proxmox_virtual_environment_user.node4_proxmin
  id       = "proxmin@pve"
}
