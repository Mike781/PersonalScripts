This will deploy an Amazon AWS instance with default settings. 

This assumes you have Terraform (Terraform.io) installed 


This is meant to be used as a standard base configuration to clone, edit
 and add extra steps depending on what needs to be installed  

Steps: 

Fill out terraform.tfvars.example and rename to terraform.tfvars 

Run -> terraform plan (to test the configuration) 

Run -> terraform apply (to deploy the configuration to AWS) 

Run -> terraform destroy (to delete/destroy the created instance) 

