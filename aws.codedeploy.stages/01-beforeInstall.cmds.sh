#!/bin/bash

die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

while ! [ -f /tmp/cloud-init.running ];
do
    echo "## Cloud-Initialization still running.."
    echo "## Check again in 5 seconds.."
    sleep 5
done
echo "## Cloud-Initialization finished.."


mkdir -p /aws.services/codedeploy/logs
touch /aws.services/codedeploy/logs/latestDeployment.logs
chmod 777 /aws.services/codedeploy/logs/latestDeployment.logs

echo "START | Executing All Commands part of the "Before-Install" LifeCycle.." >> /aws.services/codedeploy/logs/latestDeployment.logs

echo "Coping and Applying SSHd Configuration From S3.Bucket TO Root User" >> /aws.services/codedeploy/logs/latestDeployment.logs
cd ~
rm -rf ~/.ssh
mkdir -p ~/.ssh
aws s3 sync s3://global.general/SSH.Config.Files/.ssh/ ~/.ssh/ || die "Unable to Sync SSHd Config Files from S3.Bucket.."
chmod 775 ~/.ssh
chmod 600 ~/.ssh/*
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa || die "Unable to Update SSH Agent.."
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

#echo "Install GIT Software.." >> /aws.services/codedeploy/latestDeployment.logs
#yum install -y git || die "Unable to install GIT.."

echo "Cloning bridgemanart/AWS.CodeDeploy.Scripts.git Repo.." >> /aws.services/codedeploy/logs/latestDeployment.logs
cd /aws.services/codedeploy
rm -rf AWS.CodeDeploy.Scripts/
git clone git@github.com:gfisaris/aws-ec2-instance-provision-scripts.git || die "Unable to Clone bridgemanart/AWS.CodeDeploy.Scripts.git"
chmod -R 777 AWS.CodeDeploy.Scripts/

echo "FINISH | Executing All Commands part of the "Before-Install" LifeCycle.." >> /aws.services/codedeploy/logs/latestDeployment.logs
