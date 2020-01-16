
#!/bin/bash

#to set up git repo remotely.
#only during initial creation.

#export HOME=/root/
#export AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
#export REGION=$(echo $AVAIL_ZONE | sed 's/[a-z]\+$//')
export PROJECT_NAME='robs-great-project-ok'
export REPO_NAME='AmazonSageMaker-sparklingnew-repo'
export AUTHOR='Big-Rob'
export DESCRIPTION='a-fantastic-data-project'
export S3_BUCKET='2ndwatch-data-playground'

bash

cd /root/
pip install cookiecutter

echo "Configuring github for AWS credentials"
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

cp /root/.gitconfig /home/ec2-user/ && chown ec2-user:ec2-user /home/ec2-user/.gitconfig

cd SageMaker

cookiecutter https://github.com/drivendata/cookiecutter-data-science \
  project_name=$PROJECT_NAME \
  author_name=$AUTHOR \
  description=$DESCRIPTION \
  repo_name=$REPO_NAME \
  open_source_license='MIT' \
  s3_bucket=$S3_BUCKET \
  aws_profile='default' \
  python_interpreter='python3' \
  --no-input \
  --overwrite-if-exists
  #--output-dir /../ \
cd $YOUR_REPO_NAME

git add -A
git commit -m "initial data project commit"
git push origin master

#echo "Here, we'll create the scikit image pipeline"

#aws cloudformation create-stack --stack-name scikit-base \
#  --template-body file://assets/build-image.yml \
#  --parameters $(printf "$parameters" "scikit_base" "scikit-base" "latest" )

#echo "Finally we'll create iris-model pipeline"
#aws cloudformation create-stack --stack-name iris-model \#
#  --template-body file://assets/build-image.yml \
#  --parameters $(printf "$parameters" "iris_model" "iris-model" "latest" )

#parameters="$parameters ParameterKey=ModelName,ParameterValue=%s"
#parameters="$parameters ParameterKey=DatasetKeyPath,ParameterValue=%s"
#aws cloudformation create-stack --stack-name iris-train-pipeline \
#  --template-body file://assets/train-model-pipeline.yml \
#  --parameters $(printf "$parameters" "iris_model" "iris-model" "latest" "iris-model" "training_jobs/iris_model" )

#echo "Done! Let's do some stuff with this env"
