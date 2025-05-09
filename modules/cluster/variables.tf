variable "node_image" {
  type        = string
  default     = null
  description = "Name of the node image."
}

variable "name" {
  type        = string
  default     = "sandbox"
  description = "Name of the Kind cluster"
}

variable "kubeconfig_path" {
  type        = string
  default     = "~/.kube/config"
  description = "Path to the kubeconfig file to use."
}

variable "preset" {
  type = string
  default = "c1w0-exposed"
  description = "Name of the yaml file containing the preset configuration."
}