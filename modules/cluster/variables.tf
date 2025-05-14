variable "preset" {
  type        = string
  default     = "c1w0-exposed"
  description = "Name of the yaml file containing the preset configuration."
}

variable "data_path" {
  type    = string
  default = "."
}
