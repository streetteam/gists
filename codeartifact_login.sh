#!/usr/bin/env bash

set -eux

rm -f ~/.npmrc
aws codeartifact login --tool npm --domain $DOMAIN --domain-owner $AWS_ACCOUNT --repository $ARTIFACT_REPO
npm config set registry https://registry.npmjs.org/
ARTIFACT_URL=https://${DOMAIN}-${AWS_ACCOUNT}.d.codeartifact.${AWS_DEFAULT_REGION}.amazonaws.com/npm/${ARTIFACT_REPO}/
for scope in ${NPM_SCOPES} ; do
  npm config set @${scope}:registry ${ARTIFACT_URL}
done
