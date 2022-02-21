#!/usr/bin/env bash

set -eux

rm -f ~/.npmrc
##Get the AWS Codeartifact token to pull private packages
TOKEN=$(aws codeartifact get-authorization-token --domain $DOMAIN --domain-owner $AWS_ACCOUNT --output text | cut -f1)
##Get the Artifact endpoint URL
ARTIFACT_URL=$(aws codeartifact get-repository-endpoint --domain ${DOMAIN} --domain-owner ${AWS_ACCOUNT} --repository ${ARTIFACT_REPO} --format npm --output text)
##Strip https:// from the URL to set the token auth url in the config
DOMAIN_ONLY_URL=$(echo ${ARTIFACT_URL}|sed 's#https://##')
##Set the specific domains we will pull from Codeartifact
echo "//${DOMAIN_ONLY_URL}:_authToken=${TOKEN}" > ~/.npmrc
for scope in ${NPM_SCOPES} ; do
  npm config set @${scope}:registry ${ARTIFACT_URL}
done
