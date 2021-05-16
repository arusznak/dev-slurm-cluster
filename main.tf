# Telling terraform which provider to download from the Terraform Registry
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    version = "1.40.0" }
  }
}

# Configure the OpenStack Provider, the cloud itself where it will be provisioned
provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = var.auth_url
}

# resource specific configuration
resource "openstack_compute_instance_v2" "slurm-master" {
  name            = "slurm-master"
  image_id        = var.master_image_id
  flavor_id       = var.master_flavor_id
  key_pair        = var.master_key_pair
  security_groups = var.master_security_groups

  user_data = file("scripts/cloud_init_master.yaml")

  network {
    name = var.master_network_name
  }
}

# resource specific configuration
resource "openstack_compute_instance_v2" "slurm-worker" {
  count           = 2
  name            = "slurm-worker-${count.index + 1}"
  image_id        = var.worker_image_id
  flavor_id       = var.worker_flavor_id
  key_pair        = var.worker_key_pair
  security_groups = var.worker_security_groups

  user_data = templatefile("scripts/cloud_init_worker.yaml", {
    master_hostname = openstack_compute_instance_v2.slurm-master.name,
    master_ip       = openstack_compute_instance_v2.slurm-master.network[0].fixed_ip_v4,
  })

  network {
    name = var.worker_network_name
  }

# the local-exec provisioner is run locally after the creation of a resource
# and its success is based on the exit code of the command run inside
# possible use cases: ping check, port check
# ez blokkban lévő command (sleep 90s) lefog futni minden worker kilpülés után, mert a slurm-worker resource blokkon belül határoztuk meg, ha azon kívül lenne, akkor az egész infra végén futna le
# ez a command (sleep 90s) felfogja tartani a kiépülést, azaz minden worker után vár 90 mp-t, miután a következő worker el kezd épülni
# ez a worker a masterhez valo csatlakozásának a mechanizmusa miatt kell, mert percenként ellenorzi a master hogy van e új worker és ha azalatt az egy perc alatt 2 ip címet kap akkor az algoritmus tökéletlensége miatt a második felül fogja írni az elsőt (ld. cloud-init scriptek)
# itt még fontos megjegyezni, hogy a terraform by default az azonos node kiépítését párhuzamosan indítja el (parallelism=10), ezért, hogy növeljük a két node épülése közötti időt, a terraform apply-t úgy kell elindítani, hogy a -parallelism flaget 1-re állítjuk, ezzel kikapcsolva ezt a párhuzamosságot.
# (terraform apply --parallelism=1)

  provisioner "local-exec" {
    command = "sleep 90s"
  }
}

