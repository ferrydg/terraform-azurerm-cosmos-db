variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  default = "West Europe"
}

variable "name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_containers" {
  type = list(string)
}
