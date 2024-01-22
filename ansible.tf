## Ansible inventory for preparation
resource "local_file" "inventory-preparation" {
  content = <<-EOF
[kube-cloud]
${join("\n", values(yandex_compute_instance.vms).*.network_interface.0.nat_ip_address)}
EOF
  filename   = "./ansible/inventory-preparation"
  depends_on = [yandex_compute_instance.vms]
}

## Ansible inventory for Kuberspray
resource "local_file" "inventory-kubespray" {
  content = <<EOF2
all:
  hosts:
    ${yandex_compute_instance.vms["vm-master"].fqdn}:
      ansible_host: ${yandex_compute_instance.vms["vm-master"].network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vms["vm-master"].network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vms["vm-master"].network_interface.0.ip_address}
    ${yandex_compute_instance.vms["vm-worker-1"].fqdn}:
      ansible_host: ${yandex_compute_instance.vms["vm-worker-1"].network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vms["vm-worker-1"].network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vms["vm-worker-1"].network_interface.0.ip_address}
    ${yandex_compute_instance.vms["vm-worker-2"].fqdn}:
      ansible_host: ${yandex_compute_instance.vms["vm-worker-2"].network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vms["vm-worker-2"].network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vms["vm-worker-2"].network_interface.0.ip_address}
    ${yandex_compute_instance.vms["vm-worker-3"].fqdn}:
      ansible_host: ${yandex_compute_instance.vms["vm-worker-3"].network_interface.0.ip_address}
      ip: ${yandex_compute_instance.vms["vm-worker-3"].network_interface.0.ip_address}
      access_ip: ${yandex_compute_instance.vms["vm-worker-3"].network_interface.0.ip_address}
  children:
    kube_control_plane:
      hosts:
        ${yandex_compute_instance.vms["vm-master"].fqdn}:
    kube_node:
      hosts:
        ${yandex_compute_instance.vms["vm-worker-1"].fqdn}:
        ${yandex_compute_instance.vms["vm-worker-2"].fqdn}:
        ${yandex_compute_instance.vms["vm-worker-3"].fqdn}:
    etcd:
      hosts:
        ${yandex_compute_instance.vms["vm-master"].fqdn}:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
  EOF2
  filename = "./ansible/inventory-kubespray"
  depends_on = [yandex_compute_instance.vms]
}
