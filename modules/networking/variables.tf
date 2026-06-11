variable "environment" {
  type = string
}

variable "workload" {
  type = string
}

variable "location" {
  type = string
  default = "East US"
}

variable "resource_group" {
  type = string
}

variable "address_space" {
  type = list(string)
  default = ["10.0.0.0/24"]
}

variable "subnets" {
  type = map(string)
}