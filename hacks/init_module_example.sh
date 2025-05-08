#!/bin/bash

test -z "$1" && exit 1

if test -d examples; then
    cd examples
fi

mkdir "$1"
cd "$1"

touch "variables.tf"
touch "outputs.tf"

cat > terraform.tf << EOF
terraform {
    required_providers {
        # TODO
    }
}
EOF

cat > example.tf << EOF
module "example" {
    source = "../.."

    # TODO
}
EOF

cat > README.md << EOF
# Example X

What does this example do.
EOF