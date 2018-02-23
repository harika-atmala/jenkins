Terraform Scripts to Provision Jenkins Server with Load balance on Azure


Setup you private Azure creds before running the script:
subscription_id 	= "---"
client_id             = "---"
client_secret     = "---"
tenant_id           = "---"
Steps to initialize this project
•	Add storage account, container name, Access Key at the end of azure_vm.tf file for storing terraform state file remotely to azure (You need to use an already created storage account for storing the state file)
Run following commands to run & test Terraform scripts:
•	terraform init (To initialize the project)
•	terraform plan (To check the changes to be made by Terraform on azure)
•	terraform apply (To apply the changes to azure)
•	terraform show (To see all the things that the terraform apply did)
To verify whether Jenkins server is installed and up and running, just ssh into the Azure VM that have been created just by using following command,
	ssh@<public_IP>
Then enter the user name and password that have been provided in the terraform file.
After logging into the VM, enter service jenkins status and you can see the Jenkins is up and running.
Other way we can do is just enter the public IP of the VM with port 8080 then the Jenkins dashboard will be opened.
	<public_IP>:8080


The remote state file will be stored in the azure blob storage as I used the Azure Blob Storage as my backend service.
•	The Backend state file will be stored on your azure storage container.
•	This file can be used for next module.

Packer to Build Azure Jenkins Image

Create a <file name>.json file and write the code based on the requirements. A small sample is as follow,

{
  "builders": [{
    "type": "azure-arm",
subscription_id 	= "---"
client_id             = "---"
client_secret     = "---"
tenant_id           = "---"
tags {
give some tags
}

Provisioners {
give the information depending up on the requirements

}

}

Then to build the image do the following:

•	Kick off build using the command below
•	Packer build <file name>.json
•	Find your image
•	./azure-cli.sh vm image list | grep Packer
•	Create a Virtual Machine out of it

