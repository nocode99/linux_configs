#! /bin/bash
set -eo

# Install dependencies
sudo apt install -y python3-dev python3-venv libssl-dev libffi-dev stow

# create virtualenv
python3 -m venv venv

# source venv
source venv/bin/activate

# install ansible via pip
pip install -r requirements.txt

echo -e "You will need to reactivate the venv since this was installed via subshell"
