output "slurm-master" {
  value = openstack_compute_instance_v2.slurm-master.name
}

output "slurm-master-ip" {
  value = openstack_compute_instance_v2.slurm-master.network[0].fixed_ip_v4
}

output "slurm-workers" {
  value = openstack_compute_instance_v2.slurm-worker[*].name
}

output "slurm-workers-ips" {
  value = openstack_compute_instance_v2.slurm-worker[*].network[0].fixed_ip_v4
}
