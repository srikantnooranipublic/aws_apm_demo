#!/bin/bash

####
## Purpose: To set up complete AWS app env 
## Author Srikant.Noorani@Broadcom.com 
## Feb 2019
## MIT License - provided on an as is basis
#####

DATE=`date +%F_%H_%M_%S`
mkdir Logs
LOG_FILE="Logs/AWS_Logs.log.$DATE"

function LOG {

 echo "$1" | tee -a $LOG_FILE

}


DOCKER_TEMPLATE="aws_docker_yml.template"


#disabling firewall etc
if [ x"$MAC_LINUX" == "xLinux" ]; then
	setenforce 0
	sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

	systemctl stop firewalld
	systemctl disable firewalld
	systemctl start docker

fi

CONTAINERS="apm-agent jmeter dockermonitor jenkinsdockerinfrademo_dockermonitor_1"

clear
LOG ""
LOG "**********************************************"
LOG ""
LOG "**AWS Demo startup Script:** "
LOG "This will setup your complete application docker monitoring and aws IA  in a container. "
LOG ""
LOG " ##############Ensure Docker, Docker Compose is installed ######"
LOG ""
LOG "#########provide following value in aws-docker-yml.template#########"
LOG ""
LOG " <AGENT_MANAGER_URL> - EM url:port"
LOG " <APM_SAAS_CREDENTIALS> - from your SaaS agent"
LOG " <AWS_ACCESS_KEY> - AWS access Key"
LOG " <AWS_SECRET_KEY> - AWS secret key"

LOG ""
LOG " #####################################################"
LOG ""
LOG "This will remove following container (if they exists) before setting up everything again... "
LOG " $CONTAINERS"
LOG ""
LOG ""
LOG "Pls press Y and Enter to proceed....."
LOG ""
LOG "********************************************"
LOG ""

read READY

if [ x"$READY" != "xY" ]; then
	echo "Expected response "Y" was not found .. Exiting..."
	echo " "
	
	exit
fi


LOG "Deleting Containers $CONTAINERS if they exists"	

for CONTAINER in $CONTAINERS; do
	echo "removing $CONTAINER"
	docker stop $CONTAINER
	docker rm $CONTAINER

done

PWD_NEW=`echo $PWD | sed 's_/_\\\\/_g'`
sed 's/HOST_MOUNT_DIR/'$PWD_NEW'/g' $DOCKER_TEMPLATE > ${DOCKER_TEMPLATE}.changed
/bin/mv -f ${DOCKER_TEMPLATE}.changed docker-compose.yml
/bin/rm -f ${DOCKER_TEMPLATE}.changed

/bin/cp app/APP_RUNTIME/UserDaoBE.pbd app/APP_RUNTIME/wily/core/config/hotdeploy/

#Run docker compose
docker-compose  up -d


LOG ""
LOG "******* Pls wait while containers are coming up. Could take up to 20 sec"
LOG ""

sleep 20


LOG "****Pls ignore any file not found or pg_restore related error below"


docker ps

LOG ""
LOG "**********************************************"
LOG ""
LOG "Pls give it few mts for the containers to be fully up"

LOG ""
LOG ""
LOG "Use cases are available under UseCase folder in the current folder"
LOG ""
LOG "**********************************************"

LOG ""
