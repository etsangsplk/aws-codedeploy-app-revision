#!/bin/bash

die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "## Check IF cloud-init lock exist"
    while [ -f /tmp/cloud-init.running ];
    do
        echo "##-- Cloud-Initialization still running"
        echo "##-- Check again in 5 seconds"
        sleep 5
    done
echo "## Cloud-Initialization finished"

echo "## Clear any pre-existing custom CodeDeploy-Deployment Logs Folder"
    if [ -d "/aws.services/codedeploy/logs" ];
        then
            rm -rf /aws.services/codedeploy/logs
    fi

echo "## Create Folder: CodeDeploy-Deployment Logs"
    mkdir -p /aws.services/codedeploy/logs

echo "## Create File: latestDeployment.logs"
    touch /aws.services/codedeploy/logs/latestDeployment.logs
    chmod 777 /aws.services/codedeploy/logs/latestDeployment.logs

## CodeDeploy LifeCycle: "Before Install"

echo "## START CodeDeploy LifeCycle: \"Before Install\""

echo "## Coping and Applying SSHd Configuration From S3.Bucket FOR Root User"
    rm -rf ~/.ssh
    mkdir -p ~/.ssh
    aws s3 cp s3://global.general/SSH.Config.Files/.ssh/ ~/.ssh/ || die "Unable to Copy SSHd Config Files from S3.Bucket"
    chmod 775 ~/.ssh
    chmod 600 ~/.ssh/*
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa || die "Unable to Update SSH Agent"
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config


echo "## Delete, if any, pre-existing Folder: aws-ec2-instance-provision-scripts"
    if [ -d "/aws.services/codedeploy/aws-ec2-instance-provision-scripts" ];
        then
            rm -rf /aws.services/codedeploy/laws-ec2-instance-provision-scripts
    fi

echo "## Cloning Git Repo: aws-ec2-instance-provision-scripts"
    git clone git@github.com:gfisaris/aws-ec2-instance-provision-scripts.git /aws.services/codedeploy/ || die "Unable to Clone GIT Repository"
    chmod -R 777 aws-ec2-instance-provision-scripts/

echo "## END CodeDeploy LifeCycle: \"Before Install\""
