#!/bin/bash
# deploy.sh

# This script syncs the website files to the S3 bucket.
# The bucket name is passed as the first argument ($1).

set -e # Exit immediately if a command exits with a non-zero status.

echo "Deploying website to S3 bucket: $1"
aws s3 sync . s3://$1 --delete
echo "Deployment successful."
