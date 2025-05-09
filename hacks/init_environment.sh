#!/bin/bash
# Initialize a Terraform module

test -z "$1" && exit 1

if test -d environments; then
    cd environments
fi

mkdir "$1" && cd "$1"

echo "1.11.4" > .terraform-version

touch outputs.tf
touch variables.tf

cat > terraform.tf << EOF
terraform {
    required_providers {
        kind = {
        source  = "tehcyx/kind"
        version = ">=0.8.0"
        }
    }
}
EOF

cat > cluster.tf << EOF
module "cluster" {
    source = "../../modules/cluster"

    name = "sandbox" # TODO change the name
}
EOF

cat > README.md << EOF
# Environment X

Description of what the module is used for.
EOF

cat > up.sh << EOF
#!/bin/bash

terraform apply --auto-approve --target=module.cluster
terraform apply --auto-approve
EOF

cat > down.sh << EOF
#!/bin/bash

terraform destroy --auto-approve
EOF
chmod +x up.sh
chmod +x down.sh