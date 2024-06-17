#! /bin/bash

sudo yum install -y jq > /dev/null 2>&1
echo "This script provides the details about Metadata of your Azure Instance"
echo;

while [ true ];
do
	echo -e "1. For complete Azure Instance Metadata, press 1."
	echo -e "2. For compute related details, press 2."
	echo -e "3. For network related details, press 3."
	echo -e "Press Q/q to quit."
	
	read input
	if [[ $input =~ ^[Qq]$ ]] ; then
		exit
	fi
		
	if [[ ! $input =~ ^[1-3]+$ ]] ; then
		echo -e "\nPlease enter a valid option from above\n"
		continue
	fi

	if [ $input -eq 1 ]
	then
	  curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq
	elif [ $input -eq 2 ]
	then
	  echo "1. For complete compute details, press 1."
	  echo "2. For any specific meatadata in compute, press 2."

	  read input2
	  if [ $input2 -eq 1 ]
	  then
		curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/compute?api-version=2021-02-01" | jq
	  else [ $input2 -eq 2 ]
		echo "Please enter your choice from the below options:"
	    echo -e "\tosProfile"
	    echo -e "\tpublicKeys"
	    echo -e "\tstorageProfile"
			read option
			curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/compute/$option?api-version=2021-02-01" | jq
	  fi
	elif [ $input -eq 3 ]
	then
		curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/network?api-version=2021-02-01" | jq
	fi
done
