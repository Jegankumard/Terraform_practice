# Terraform_practice - Terraform Command Lines:

### Terraform CLI tricks

Setup tab auto-completion, requires logging back in
```
terraform -install-autocomplete
```    


### Format and Validate Terraform code

format code per HCL canonical standard
```
terraform fmt
```                           
validate code for syntax
```
terraform validate
```
validate code skip backend validation
```
terraform validate -backendfalse
```


### Initialize your Terraform working directory

initialize directory, pull down providers
```
terraform init                       
```
initialize directory, do not download plugins
```
terraform init -get-pluginsfalse
```
initialize directory, do not verify plugins for Hashicorp signature
```
terraform init -verify-pluginsfalse
```
Ask for input if necessary
```
terraform init -inputtrue
```     
Disable locking of state files during state-related operations
```
terraform init -lockfalse
```


### Plan, Deploy and Cleanup Infrastructure

Creates an execution plan (dry run)
```
terraform plan
```
save generated plan output as a file
```
terraform plan -outplan.out
```
Outputs a destroy plan
```
terraform plan -destroy
```
Executes changes to the actual environment
```
terraform apply
```
use the plan.out plan file to deploy infrastructure
```
terraform apply plan.out
```
Apply changes without being prompted to enter ”yes”
```
terraform apply –auto-approve
```
lock the state file so it can't be modified by any other terraform apply or modification action
```
terraform apply -locktrue
```
Update the state for each resource prior to planning and applying
```
terraform apply -refreshtrue
```
Ask for input for variables if not directly set
```
terraform apply -inputfalse
```
Set a variable in the terraform configuration, can be used multiple times
```
terraform apply -var ‘my_region_variableus-east-1’
```
Specify a file that contains key/value pairs for variable values
```
terraform apply -var-filefoo
```
Only apply/deploy changes to the targeted resource
```
terraform apply -targetaws_instance.my_ec2
```
Destroy/cleanup without being prompted to enter ”yes”
```
terraform destroy –auto-approve
```
Only destroy the targeted resource and its dependencies
```
terraform destroy -target
``` 
do not reconcile state file with real-world resources(helpful with large complex deployments )
```
terraform apply refreshfalse
```
number of simultaneous resource operations
```
terraform apply --parallelism5
```
reconcile the state in terraform state file with real-world resources
```
terraform refresh
```
get information about providers used in current configuration
```
terraform providers
```               


### Terraform Workspaces

create a new workspace
```
terraform workspace new mynewworkspace
```
change to the selected workspace
```
terraform workspace select default
``` 
 list out all workspaces
 ```
terraform workspace list
```     
 Show the name of the current workspace
 ```
terraform workspace show
``` 
Delete an empty workspace
```
terraform workspace delete
```      


### Terraform State Manipulation

show details stored in Terraform state for the resource
```
terraform state show aws_instance.my_ec2
```
download and output terraform state to a file
```
terraform state pull > terraform.tfstate
```
move a resource tracked via state to different module
```
terraform state mv aws_iam_role.my_ssm_role module.custom_module
```    
replace an existing provider with another
```
terraform state replace-provider hashicorp/aws registry.custom.com/aws
```
list out all the resources tracked via the current state file
```
terraform state list
```            
unmanage a resource, delete it from Terraform state file
```
terraform state rm  aws_instance.myinstace
```
Refresh state file
```
terraform state refresh
```


### Terraform Import And Outputs

import EC2 instance with id i-abcd1234 into the Terraform resource named "new_ec2_instance" of type "aws_instance"
```
terraform import aws_instance.new_ec2_instance i-abcd1234
```
same as above, imports a real-world resource into an instance of Terraform resource
```
terraform import 'aws_instance.new_ec2_instance[0]' i-abcd1234
```
list all outputs as stated in code
```
terraform output
```                
list out a specific declared output
```
terraform output instance_public_ip
```
list all outputs in JSON format
```
terraform output -json
```   
provide human-readable output from a state or plan file
```
terraform show
```                 


### Terraform Miscelleneous commands

display Terraform binary version, also warns if version is old
```
terraform version
```
downloads and update modules mentioned in the root module
```
terraform get
```
download and update modules in the "root" module
```
terraform get -updatetrue
```


### Terraform Console(Test out Terraform interpolations)

echo an expression into terraform console and see its expected result as output
```
echo 'join(",",["foo","bar"])' | terraform console
```
Terraform console also has an interactive CLI just enter "terraform console"
```
echo '1 + 5' | terraform console
```
display the Public IP against the "my_ec2" Terraform resource as seen in the Terraform state file
```
echo "aws_instance.my_ec2.public_ip" | terraform console
```


### Terraform Graph(Dependency Graphing)

produce a PNG diagrams showing relationship and dependencies between Terraform resource in your configuration/code
```
terraform graph | dot -Tpng > graph.png     
```


### Terraform Taint/Untaint(mark/unmark resource for recreation -> delete and then recreate)

taints resource to be recreated on next apply
```
terraform taint aws_instance.my_ec2     
```
Remove taint from a resource
```
terraform untaint aws_instance.my_ec2   
```
forcefully unlock a locked state file, LOCK_ID provided when locking the State file beforehand
```
terraform force-unlock LOCK_ID          
```


### Terraform Cloud

obtain and save API token for Terraform cloud
```
terraform login
```
Log out of Terraform Cloud, defaults to hostname app.terraform.io
```
terraform logout
```

