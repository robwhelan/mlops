export AWS_PROFILE=2ndwatch
export STACK_NAME=mlops-format-name
export PROJECT_NAME='robs-format-name'
export ML_ZONE_BUCKET='2ndwatch-data-playground'

export MY_STACK=$(aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://main.yaml \
  --capabilities CAPABILITY_IAM \
  --disable-rollback \
  --parameters \
    ParameterKey=pMLZoneBucket,ParameterValue=$ML_ZONE_BUCKET \
    ParameterKey=pProjectName,ParameterValue=$PROJECT_NAME \
  --output text )

echo $MY_STACK
