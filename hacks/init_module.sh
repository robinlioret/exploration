#!/bin/bash
# Initialize a Terraform module

echo "1.11.4" > .terraform-version

touch main.tf
touch outputs.tf
touch variables.tf

cat > terraform.tf << EOF
terraform {
    required_providers {
        # TODO
    }
}
EOF

cat > README.md << EOF
# Module X

Description of what the module is used for.
EOF

mkdir examples