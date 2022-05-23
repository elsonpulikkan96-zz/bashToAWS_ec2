#!/bin/bash
printf ' \n'
printf '******** Welcome to aws cli *************\n '
printf '\n'
date
printf ' \n'
printf  ' a)---->Create AWS Security group , Secret key and Launch the instance \n'
printf  ' b)----> aws instance stop\n'
printf  ' c)----> aws instance start\n'
printf  ' d)----> aws instance status\n'
printf  ' f)----> aws instance remove\n'
printf ' \n'
read DISTR
case $DISTR in
  	a)
      	read -p "Enter your name for the security group : " name
      	printf 'Now you are creating an aws security group\n'
      	printf '%s\n' --------------------------------------------------
      	printf ' \n'
      	getsgid=`aws ec2 create-security-group --group-name $name  --description "SG for Ec2 with ssh and https" --output text | awk '{ print $1 }'`
      	echo " You Security Group Id is = $getsgid"
      	printf ' \n'
      	aws ec2 authorize-security-group-ingress --group-name $name --protocol tcp --port 22 --cidr 0.0.0.0/0 --port 80 --cidr 0.0.0.0/0 --output text
      	read -p "Enter a key name for the user: " key
      	aws ec2 create-key-pair --key-name $key --query 'KeyMaterial' --output text > $key.pem
      	chmod 400 $key.pem
      	printf ' \n'
      	printf 'Choose any AMI from the US-EAST-1\n'
      	printf ' \n'
      	printf '(Note:- If your location is not US-EAST-1 Choose the default  AMI-ID from your Console)\n'
      	printf ' \n'
      	printf ' 1. Ubuntu Server 22.04 LTS- ami-09d56f8956ab235b3\n 2. Amazon Linux 2- ami-0022f774911c1d690\n 4. Red Hat Enterprise Linux 8.2- ami-0f095f89ae15be883\n'
      	printf ' \n'
      	read  -p "You need to choose and Enter a valid AMI-ID from the above list: " amid
      	echo " Your AWS instance is now launching"
      	printf '%s\n'  ---------------------------------------------------
      	instaid=`aws ec2 run-instances --image-id $amid --security-group-ids $getsgid --count 1 --instance-type t2.micro --key-name $key --output text | awk 'FNR == 2 {print $8}'`
      	echo " Your AWS instance I.D = $instaid"
      	printf ' \n'
      	ipaddr=`aws ec2 describe-instances --instance-ids $instaid --query 'Reservations[0].Instances[0].PublicIpAddress'`
      	echo " Public I.P of the instance = $ipaddr"
      	printf ' \n'
      	aws ec2 describe-instances --instance-ids $instaid --output text | awk 'FNR == 2 {print $8}' > instadet.txt
      	;;  
 	b)  read -p " Press Enter to stop the instance "
     	instop=`cat instadet.txt`
     	echo " Your AWS instance is going stop"
     	printf '%s\n'  ----------------------------------------------
     	printf ' \n'
     	aws ec2 stop-instances --instance-ids $instop --output text
     	;; 	 
  	c)
     	read -p " Press Enter to start your instance "
     	instart=`cat instadet.txt`
     	echo " Your AWS instance is going start normally"
     	printf '%s\n'  -----------------------------------------------
     	printf ' \n'
     	aws ec2 start-instances --instance-ids $instart --output text
     	;;
  	d)
     	read -p " Press Enter to get the details of your Instance"
     	instadesc=`cat instadet.txt`
     	echo " Status of your AWS instance "
     	printf '%s\n'  -------------------------------------------
     	printf ' \n'
     	aws ec2 describe-instance-status --instance-id $instadesc --output text
     	;;
 	f)  
     	read -p " Press Enter to Terminate your Instancce"
     	instaterm=`cat instadet.txt`  	 
     	echo " Caution...! Are you sure about this..??"
     	printf '%s\n'  ------------------------------------------
     	printf ' \n'
     	aws ec2 terminate-instances --instance-ids $instaterm --output text
     	;;
  esac
