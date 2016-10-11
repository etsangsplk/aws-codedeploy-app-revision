#!/bin/bash

die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "START | Executing all Commands that are part of "Validate-Service" LifeCycle.." >> /aws.services/codedeploy/logs/latestDeployment.logs
cd /aws.services/codedeploy/AWS.CodeDeploy.Scripts
sh execute.validate.service.cmds.sh || die "Execution of a Command Failed! Please check Deployment logs for more informations.."
echo "FINISH | Executing all Commands that are part of "Validate-Service" LifeCycle.." >> /aws.services/codedeploy/logs/latestDeployment.logs
