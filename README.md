#TECH test documentation
## 1.part
file: _vpc.yaml_  
This file describes mainly these AWS resources: 

- VPC
- VPC subnet
- EC2 instance

###How to use this template

1. Open AWS console, set Virginia region and go to the Cloudformation service
2. Click on "Create Stack button"
3. Choose option with uploading template from file and choose vpc.yaml from this git repository
4. Put into input name of the stack
5. Choose SSH key
6. Click on the Next button till the end.
7. That's it. Wait a few moments. You have successfully created your stack.

## 2.part
file: _main.tf_  
This file contains terraform configuration

###How  to use this config
1. Set aws credentials using ~/.aws/credentials or add appropriate keys into config into provider section. I used aws config
2. run ```terraform init```
3. run ```terraform apply -var 'ssh_key=test' -auto-approve``` here put your existing ssh key name (non-interactive)
4. DONE

To remove stack run following:  
```terraform destroy -auto-approve``` (non-interactive)