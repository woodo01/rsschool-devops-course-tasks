# Terraform AWS Infrastructure

## Overview
This repository contains Terraform code to manage AWS resources using GitHub Actions for CI/CD.

## Setup
1. Create an IAM user with MFA and necessary permissions.
2. Set up GitHub Secrets for AWS credentials:
   - `AWS_ROLE_ARN`: The ARN of the IAM role.
   - `AWS_REGION`: The AWS region where resources are deployed.
3. Configure the workflow to trigger on push or pull request to the main branch.

## Running the Workflow
The GitHub Actions workflow runs the following:
- **Check**: Checks Terraform formatting.
- **Plan**: Plans the deployment.
- **Apply**: Applies the Terraform changes if on the main branch.

## Verification
To verify the setup:
1. Execute Terraform plans to ensure they run successfully.
