#!/bin/bash

# Generate ssh key to use to log into the metal-cubed servers
ssh-keygen -t ed25519 -C "m3-demo" -f ~/.ssh/id_ed25519 -N ""

# Copy over pre-configured extra_vars file
cp ~/metal3-demo/scripts/required-files/pre-configured_extra_vars.yml ~/metal3-demo/extra_vars.yml

# Take the generated key and put it in extra_vars.yml
PUBLIC_KEY_FILE="$HOME/.ssh/id_ed25519.pub"
PUBLIC_KEY=$(cat "$PUBLIC_KEY_FILE")

SEARCH_STRING="-YOU CAN REPLACE THIS BUT THE SCRIPT WILL CHANGE THIS AUTOMATICALLY"
REPLACE_STRING="- $PUBLIC_KEY"

perl -i -pe "s|$SEARCH_STRING|$REPLACE_STRING|" ~/metal3-demo/extra_vars.yml


# Run the playbook with the verbose flag
ansible-playbook ~/metal3-demo/scripts/playbooks/m3-playbook.yaml -v

cd ~/metal3-demo; ./setup_metal3_network_infra.sh -vvv 

cd ~/metal3-demo; ./setup_metal3_core.sh -vvv
