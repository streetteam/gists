#!/usr/bin/env bash

set -eux

rm -f ~/.npmrc
##Get the AWS Codeartifact token to pull private packages
TOKEN=$(aws codeartifact get-authorization-token --domain $DOMAIN --domain-owner $AWS_ACCOUNT --output text | cut -f1)
##Get the Artifact endpoint URL
ARTIFACT_URL=$(aws codeartifact get-repository-endpoint --domain ${DOMAIN} --domain-owner ${AWS_ACCOUNT} --repository ${ARTIFACT_REPO} --format npm --output text)
##Strip https:// from the URL to set the token auth url in the config
DOMAIN_ONLY_URL=$(echo ${ARTIFACT_URL}|sed 's#https://##')
##Extra params from common_lib.packaging.credential.NpmLoginOverride.get_npmrc_content
echo "//${DOMAIN_ONLY_URL}:always-auth=true" > ~/.npmrc
echo "//${DOMAIN_ONLY_URL}:_authToken=${TOKEN}" >> ~/.npmrc
echo "legacy-peer-deps=true" >> ~/.npmrc

for scope in ${NPM_SCOPES} ; do
  npm config set @${scope}:registry ${ARTIFACT_URL}
done
