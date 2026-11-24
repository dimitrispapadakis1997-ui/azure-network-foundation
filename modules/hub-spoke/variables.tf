variable "name" {
  description = "Short name of the environment, used in resource names (for example dev or prod)."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "hub_address_space" {
  description = "Address space of the hub virtual network. Must be a /16."
  type        = string
}

variable "spokes" {
  description = "Spoke virtual networks: map of spoke name to its address space (each a /16)."
  type        = map(string)
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
