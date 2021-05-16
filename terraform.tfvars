#cloud
tenant_name = "occopus"

auth_url = "https://sztaki.cloud.mta.hu:5000/v3"


# master
master_image_id = "da6e3e71-9535-459a-a367-95feb379bfd4"

master_flavor_id = "3"

master_key_pair = "takacszs-key"

master_security_groups = ["ALL"]

master_network_name = "OCCOPUS_net"

#worker
worker_image_id = "da6e3e71-9535-459a-a367-95feb379bfd4"

worker_flavor_id = "4740c1b8-016d-49d5-a669-2b673f86317c"

worker_key_pair = "takacszs-key"

worker_security_groups = ["ALL"]

worker_network_name = "OCCOPUS_net"
