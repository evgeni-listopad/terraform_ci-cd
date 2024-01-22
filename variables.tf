# Variables
variable "yc_cloud_id" {
  default = "b1gkjk5reuc4u9svu54m"
}

variable "yc_folder_id" {
  default = "b1gj45vv7fpc7kmc184h"
}

variable "yc_zone" {
  default = "ru-central1-a"
}

variable "subnet_names" {
  type    = list(string)
  default = ["subnet-a", "subnet-b", "subnet-c"]
}

variable "zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
}

variable "instances" {
  type = map(object({
    name      = string
    hostname  = string
    zone      = string
    cores     = number
    memory    = number
    subnet_id = number
  }))
  default = {
    "vm-master"  = { name = "vm-master", hostname = "vm-master", zone = "ru-central1-a", cores = 2, memory = 4, subnet_id = 0 },
    "vm-worker-1" = { name = "vm-worker-1", hostname = "vm-worker-1", zone = "ru-central1-a", cores = 2, memory = 2, subnet_id = 0 },
    "vm-worker-2" = { name = "vm-worker-2", hostname = "vm-worker-2", zone = "ru-central1-b", cores = 2, memory = 2, subnet_id = 1 },
    "vm-worker-3" = { name = "vm-worker-3", hostname = "vm-worker-3", zone = "ru-central1-c", cores = 2, memory = 2, subnet_id = 2 },
  }
}
