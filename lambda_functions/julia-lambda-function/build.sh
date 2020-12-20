#!/bin/bash

pwd

aws cloudformation package --force-upload --template-file template.yml --s3-bucket packeages  --output-template template-export.yml

aws cloudformation deploy --force-upload --template-file template-export.yml --s3-bucket sam-packeages  \
  --s3-prefix $FUNCTION --stack-name "${TAG}-${STAGE}" --capabilities "CAPABILITY_IAM" --region ap-northeast-1 

aws cloudformation describe-stacks --stack-name "${TAG}-${STAGE}" --query 'Stacks[]'


exit 0
