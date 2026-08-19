# modules/netdata — declarative Netdata agent config (stream.conf + go.d
# prometheus collectors) pushed over SSH. Complements, does not replace,
# the existing quadlet-based container deploy (see root quadlets.tf) —
# this module only manages the two config files Netdata reads at startup;
# it does not install the package or manage the container/quadlet unit.
#
# install_mode = "native": files land under /etc/netdata (host package
#   installed out-of-band via the official kickstart installer) and the
#   systemd unit is restarted on change.
# install_mode = "container": files land under /etc/netdata (bind-mounted
#   into the netdata quadlet container's /etc/netdata via the existing
#   netdataconf volume) and the podman-managed unit is restarted on change.
#   Either way the destination path and restart command only differ in the
#   unit name, so both branches share one provisioner shape.

locals {
  restart_unit = var.install_mode == "native" ? "netdata" : "netdata.service"

  stream_conf = templatefile("${path.module}/templates/stream.conf.tftpl", {
    is_parent          = var.is_parent
    stream_parent_host = var.stream_parent_host
    stream_parent_port = var.stream_parent_port
    stream_api_key     = var.stream_api_key
  })

  prometheus_conf = templatefile("${path.module}/templates/prometheus.conf.tftpl", {
    collectors = var.collectors
  })
}

resource "null_resource" "stream_conf" {
  triggers = {
    content = sha256(local.stream_conf)
  }

  connection {
    type  = "ssh"
    host  = var.ssh_host
    user  = var.ssh_user
    agent = true
  }

  provisioner "file" {
    content     = local.stream_conf
    destination = "/etc/netdata/stream.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl restart ${local.restart_unit}",
    ]
  }
}

resource "null_resource" "prometheus_conf" {
  triggers = {
    content = sha256(local.prometheus_conf)
  }

  connection {
    type  = "ssh"
    host  = var.ssh_host
    user  = var.ssh_user
    agent = true
  }

  provisioner "file" {
    content     = local.prometheus_conf
    destination = "/etc/netdata/go.d/prometheus.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl restart ${local.restart_unit}",
    ]
  }
}
