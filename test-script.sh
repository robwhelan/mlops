#!/bin/bash
set -e
echo 'becoming the ec2-user until EOF'
sudo -u ec2-user -i <<EOF

echo "Configuring github for AWS credentials";

git config --global credential.helper '!aws codecommit credential-helper $@';
git config --global credential.UseHttpPath true;

echo 'getting into the sm directory'
cd /home/ec2-user/SageMaker;

export LC_ALL=en_US.UTF-8;
export LANG=en_US.UTF-8;
export LANGUAGE=en_US.UTF-8;
export HOME=/root/;
export PROJECT_NAME=robs-project16;
export REPO_NAME=robs-project16-notebook-repository;
export S3_BUCKET=2ndwatch-data-playground;
export REPO_URL=https://git-codecommit.us-east-1.amazonaws.com/v1/repos/robs-project16-notebook-repository
#PACKAGE=cookiecutter
#PACKAGE2=jupyter_contrib_nbextensions
echo 'repo name'
echo $REPO_NAME

# Note that "base" is special environment name, include it there as well.
for env in base /home/ec2-user/anaconda3/envs/*; do
    source /home/ec2-user/anaconda3/bin/activate $(basename "$env")
    if [[ "$env" = "JupyterSystemEnv" ]]; then
      continue
    fi
    pip install --upgrade cookiecutter
    cookiecutter https://github.com/drivendata/cookiecutter-data-science \
      project_name=$PROJECT_NAME \
      repo_name=$REPO_NAME \
      open_source_license='MIT' \
      s3_bucket=$S3_BUCKET \
      aws_profile='default' \
      python_interpreter='python3' \
      --no-input \
      --overwrite-if-exists;

    source /home/ec2-user/anaconda3/bin/deactivate
done

echo 'list of files:';
ls;
echo 'cloning into repo'
git clone $REPO_URL;
echo 'changing into repo'
cd $REPO_NAME;
echo 'trying to push to git, project 12'
git add -A;
git commit -m "initial data project commit";
git push origin master;

#jupyter contrib nbextension install
#jupyter nbextension enable codefolding/main
echo 'reached EOF'
EOF
echo $PWD
