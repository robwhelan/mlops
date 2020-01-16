export AWS_PROFILE=2ndwatch
export ENDPOINT_NAME=glue-dev-endpoint
export ROLE_ARN=

aws glue create-dev-endpoint \
  --endpoint-name $ENDPOINT_NAME \
  --role-arn $ROLE_ARN \
  --worker-type Standard \
  --glue-version 1.0 \
  --number-of-workers 1

aws glue get-dev-endpoint \
  --endpoint-name $ENDPOINT_NAME \
  --query DevEndpoint.Status \
  --output text
