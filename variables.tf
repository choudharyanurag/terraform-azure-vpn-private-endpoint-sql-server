variable "isSiteToSiteVPNSetup" {
  type        = bool
  default     = false
  description = "description"
}

variable "root_cert_file" {
  type = string
}

variable "local_network_gateway_public_ip" {
  type = string
}