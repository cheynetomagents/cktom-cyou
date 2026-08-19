# modules/netdata

Declarative Netdata agent configuration: renders `stream.conf` (parent/child
streaming) and `go.d/prometheus.conf` (app metrics scrape jobs) and pushes
them to a host over SSH, restarting the netdata unit on change.

This module does **not** install Netdata or manage the container/quadlet
unit — pair it with:
- a host already running the official kickstart-installed native package
  (`install_mode = "native"`), or
- the existing quadlet-based container deploy in root `quadlets.tf`
  (`install_mode = "container"`), which already bind-mounts
  `/etc/netdata` via the `netdataconf` volume.

## Usage

Streaming parent (receives from children):

```hcl
module "netdata_example_parent" {
  source = "./modules/netdata"

  hostname     = "prod3"
  ssh_host     = var.prod3_host
  ssh_user     = "prodmin"
  install_mode = "container"
  is_parent    = true

  stream_api_key = var.netdata_stream_api_key
}
```

Streaming child (sends to the parent above), with an app metrics collector:

```hcl
module "netdata_example_child" {
  source = "./modules/netdata"

  hostname            = "some-vm"
  ssh_host            = "some-vm.lab.sf.cktom.cyou"
  install_mode        = "native"
  is_parent           = false
  stream_parent_host  = var.prod3_host
  stream_api_key      = var.netdata_stream_api_key

  collectors = [
    { job_name = "myapp", url = "http://localhost:9090/metrics" },
  ]
}
```

`stream_api_key` must be identical across parent and all children — generate
once with `uuidgen`, store in a `*.tfvars.sops` file per repo convention
(`.sops.yaml`), never commit in plaintext.
