# bashToAWS_ec2

This simple Automated BASH scirpt would launch an AWS EC2 Instance.

Compenents.

####### Automated set up of AWS SG, Pem file and Inbound/Outbound network rules rules #########

######### Autoamted setup of Ec2 instance with given AMI ids from the pool #########

######### Display generated instance details along with the public IPv4 and Instance ID #########


Prequesties
----------------
Configure a IAM user with the Administrator privileges

Install and configure AWS cli on local Ubuntu machine

Setup
---------------
touch aws_ec2.sh

chmod +x aws_ec2.sh

bash aws_ec2.sh
