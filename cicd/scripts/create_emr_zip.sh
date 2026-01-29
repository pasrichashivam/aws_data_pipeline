#!/bin/bash

ENV=$1
ARTIFACT_BUCKET="emr-app-artifacts-${ENV}"

rm -rf build
mkdir build

pip install -r requirements.txt -t build/
cp -r src build/

cd build
zip -r emr_dependencies.zip .
aws s3 cp emr_dependencies.zip s3://${ARTIFACT_BUCKET}/dependencies/
