#!/usr/bin/env bash

set -eux

rm -f ~/.npmrc
aws codeartifact login --tool npm --domain $DOMAIN --domain-owner $AWS_ACCOUNT --repository $ARTIFACT_REPO
npm config set registry https://registry.npmjs.org/
ARTIFACT_URL=$(aws codeartifact get-repository-endpoint --domain ${DOMAIN} --domain-owner ${AWS_ACCOUNT} --repository ${ARTIFACT_REPO} --format npm)
for scope in ${NPM_SCOPES} ; do
  npm config set @${scope}:registry ${ARTIFACT_URL}
done
