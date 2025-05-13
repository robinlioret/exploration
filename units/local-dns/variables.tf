variable "domain" {
  type        = string
  default     = "sandbox.local"
  description = "Local domain to be served"
}

variable "local-ip" {
  type        = string
  default     = "127.0.0.1"
  description = "Local ip of the computer you're working on. It will be used to resolve the subdomains."
}
