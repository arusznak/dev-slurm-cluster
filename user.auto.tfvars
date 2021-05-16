# ide kerüljenek azok a változók amelyeket a user ad meg:
#    worker ssh kulcs pár
#    worker számossága
# és akkor az itt megadottakra fogunk hivatkozni a main.tf-ben a templatefile-ban: var.xy
# a terraform minden .auto.tfvars fájlt beolvas, ezért szerintem az a legjobb megoldás ha egy ilyenbe kerjuk meg a user-t h irja be a dolgait.
