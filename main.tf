terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone = var.yc_zone
}

# VPC
resource "yandex_vpc_network" "network-diploma" {
  name = "network-diploma"
  folder_id = var.yc_folder_id
}

# Subnets
resource "yandex_vpc_subnet" "subnets" {
  count = length(var.subnet_names)

  name           = var.subnet_names[count.index]
  zone           = var.zones[count.index]
  network_id     = yandex_vpc_network.network-diploma.id
  v4_cidr_blocks = [var.cidr_blocks[count.index]]
}

# Virtual machines
resource "yandex_compute_instance" "vms" {
  for_each = var.instances

  name = each.value.name
  hostname = each.value.hostname
  zone = each.value.zone

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = "fd84nt41ssoaapgql97p"
      size     = "10"
    }
  }

  network_interface {
#    subnet_id = each.value.subnet_id    
    subnet_id = yandex_vpc_subnet.subnets[each.value.subnet_id].id
# subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

