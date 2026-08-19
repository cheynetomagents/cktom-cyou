# Netdata streaming config for prod3, acting as the streaming parent
# (matches the existing `parentrouter` Traefik label on quadlet/netdata.container,
# which already exposes SNI passthrough at parent.prod.sf.cktom.cyou:443).
#
# This only manages stream.conf + go.d/prometheus.conf on the host already
# running the netdata quadlet container (see quadlets.tf). Child hosts point
# their own module "netdata" block's stream_parent_host at prod3 and share
# the same stream_api_key (sourced from sops, never plaintext — see README).
#
# netdata_stream_api_key: shared Netdata streaming API key (UUID). Generate
# with `uuidgen`, store in a *.tfvars.sops file per repo convention (see
# .sops.yaml), never commit in plaintext.
variable "netdata_stream_api_key" {
  description = "Shared Netdata streaming API key (UUID) — same value in the parent's [API_KEY] stanza and every child's [stream] stanza. Source via sops-encrypted tfvars."
  type        = string
  sensitive   = true
  default     = null
}

module "netdata_prod3_parent" {
  source = "./modules/netdata"

  hostname     = "prod3"
  ssh_host     = var.prod3_host
  ssh_user     = "prodmin"
  install_mode = "container"
  is_parent    = true

  stream_api_key = var.netdata_stream_api_key
}
