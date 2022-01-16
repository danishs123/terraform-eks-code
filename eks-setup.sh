#!/bin/bash

set +x

#git clone https://innersource.soprasteria.com/group-cloud-coe/devopsaccelerator-platform/devopsaccelerator-modules/aws

echo "#######-----Terraform Prep------########"

terraform --version

#cd sourcecode/awslandingzoneimp/datasync-service/datasync-task/terraform
terraform init -backend-config="key=terraform-k8s-test.tfstate"

echo "#######-----Terraform Plan------########"
rm -f terraform.tfplan
terraform plan -var-file=terraform.tfvars -out terraform.tfplan

echo "#######-----Terraform Apply------########"
terraform apply terraform.tfplan