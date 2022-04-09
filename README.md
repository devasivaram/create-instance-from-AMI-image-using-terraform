# Create-instance-from-AMI-image-using-terraform

## Description

We are creating an instance from AMI image of an instance using terraform. Here we use filters to specificaly pick the desired AMI image.

## Prerequisites for this project

- Need AWS CLI access or IAM user access with attached policies for the creation of EC2.
- Terraform need to be installed in your system.
- Knowledge to the working principles of each AWS services especially EC2 and AMI, also terraform.

## Installation

If you need to download terraform , then click here [Terraform](https://www.terraform.io/downloads.html) .

## Steps performed

## Step 1

Create an and EC2 instance with name tag "template", once the instance is successfully lauched, we get into the instance and install HTTPD and PHP to the instance.

![image](https://user-images.githubusercontent.com/100773863/162455135-7c999ad2-9db9-4913-b35c-b81867b1e7ca.png)


> To add HTTPD and PHP

~~~sh
yum install httpd -y
systemctl restart httpd.service
systemctl enable httpd.service
amazon-linux-extra install php7.4 -y
~~~

## Step 2

Now, we need to add an sample HTML template to the instance and attach to document root, you can use this link for getting [sample HTML](https://www.tooplate.com/) . 
Here we downloaded the template to /var/website/ location.

> To get sample HTML template

~~~sh
wget https://www.tooplate.com/zip-templates/2126_antique_cafe.zip /var/website/
cd /var/website/
unzip 2126_antique_cafe.zip
cp -r 2126_antique_cafe/* /var/www/html/
chown -R apache:apache /var/www/html/*
systemctl restart httpd.service
~~~

## Step 3


Now verify the site is working with the added template and once it is working properly we need to create an AMI image of that instance and we need to add some tags to that AMI image.

![image](https://user-images.githubusercontent.com/100773863/162455364-f7177029-2190-473f-9a9c-af2c00f0f30a.png)

So the tags I used are:
Name = myapp-version-1
project = uber
env = prod

![image](https://user-images.githubusercontent.com/100773863/162455746-6fc77274-e5bc-4492-afe7-f9bdeef36edb.png)

![image](https://user-images.githubusercontent.com/100773863/162464068-39d2a2ab-d132-468d-a53f-1ed42cb94167.png)


You can use any tags as you like, but please remember those tags, because we use these tags for setting filters in terraform.

## Step 4

Once the AMI image creation is complete, create an instance for using terraform (You can use the previous instance but please ensure that you enable no reboot while creating image of that instance, because if it is not enabled it will make that instance reboot while performing the AMI creation)

> To download and install terraform

~~~sh
wget https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
unzip terraform_1.1.7_linux_amd64.zip
mv terraform /usr/local/bin/
~~~

## Step 5

Now, we create an directory for our project and move to that directory. After that create 3 files (main.tf, datasource.tf and provider.tf)

~~~sh
mkdir myproject
cd myproject/
touch main.tf datasource.tf provider.tf
~~~
 
Lets create a file for declaring the provider/IAM user.This is used to declare the user access key and secret key for accessing instance.
 
 ## Create a provider.tf file

~~~
provider "aws" {
  region     = provide your region
  access_key = provide your access key
  secret_key = provide your secret key
}
~~~

*** we need initiate terraform after adding provider.tf file: ***

~~~sh
terraform init
~~~

## Create a datasource.tf file

~~~sh
data "aws_ami" "myapp-ami" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "tag:Name"
    values = ["myapp-version-*"]
        }
  filter {
        name = "tag:env"
    values = ["prod"]
        }
  filter {
        name = "tag:project"
    values = ["uber"]
        }
}
~~~

Here you can see the filter we have added to grab the desired AMI image.

## Create a main.tf file

~~~sh
resource "aws_instance"  "myapp-instance" {

  ami                     =    data.aws_ami.myapp-ami.id
  instance_type           =    "t2.micro"
  key_name                =    aws_key_pair.devopsnew.id
  vpc_security_group_ids  =    ["add your sec.grp ID"]
  tags = {
    Name = "myapp"
  }
}

resource "aws_key_pair" "devopsnew" {

  key_name = "devopsnew1"
  public_key = file("path to your key.pub")
  tags = {
    Name = "devopsnew1"
  }
}
~~~

You can use either your active key pair in key section or you can generate new key using:

~~~sh
ssh-keygen
~~~

Lets validate the terraform files using

```
terraform validate
```

Lets plan the architecture and verify once again

```
terraform plan
```

Lets apply the above architecture to the AWS.

```
terraform apply
```

Now the instance is created from AMI image using terraform:

![image](https://user-images.githubusercontent.com/100773863/162464330-c05a51d8-5962-439b-a67f-a7fd5a74c547.png)
 

## Conclusion

This is a simple EC2 creation from AMI image using terraform with filter. Please contact me when you encounter any difficulty error while using this terrform code. Thank you and have a great day!


### ⚙️ Connect with Me
<p align="center">
<a href="https://www.instagram.com/dev_anand__/"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white"/></a>
<a href="https://www.linkedin.com/in/dev-anand-477898201/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"/></a>

