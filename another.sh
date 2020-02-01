#!/bin/bash
set -e
sudo -u ec2-user -i <<EOF
PACKAGE=scipy
for env in base /home/ec2-user/anaconda3/envs/*
do
  source /home/ec2-user/anaconda3/bin/activate $(basename "$env")
  if [[ "$env" = "JupyterSystemEnv" ]]
  then
    continue
  fi
  pip install --upgrade cookiecutter
  deactivate
done
EOF
