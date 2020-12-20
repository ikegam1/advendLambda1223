#!/bin/bash

env
install -y tree
yum install -y curl
yum install -y perl

tree -d -l .

GITURL="$CODEBUILD_SOURCE_REPO_URL"
DATETIME=`date -d '9 hours' "+%Y/%m/%d-%H:%M:%S"`

# lambda_functions/deploy-test
if [[ `echo $CODEBUILD_WEBHOOK_HEAD_REF | grep '/tags/'` ]]; then
  echo 'trigger is tags'
else
  exit 1
fi

export TAG=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | cut -d '/' -f 3 | cut -d '.' -f 1)
export STAGE=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | cut -d '/' -f 3 | cut -d '.' -f 2)
export FUNCTION="${TAG}-${STAGE}"

if [[ -d lambda_function/$TAG ]]; then
  MESSAGE="tag名に一致するdirectoryが存在しませんでした usage: [function-name]-[stage].[version]"
  echo $MESSAGE
  exit 1
fi

cd lambda_functions/$TAG
/bin/bash ./build.sh
cd ../../

MESSAGE="${TAG}-${STAGE}をリリースしました"
echo $MESSAGE

exit 0
