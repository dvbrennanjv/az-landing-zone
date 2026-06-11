variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type    = string
  default = "East US"
}

variable "storage_replication_type" {
  type    = string
  default = "LRS"
}
