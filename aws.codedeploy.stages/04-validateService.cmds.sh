#!/bin/bash

die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "START CodeDeploy LifeCycle: \"Validate Service\""
    bash /aws.services/codedeploy/aws-ec2-instance-provision-scripts/execute.validate-service.cmds.sh || die "Execution of a Command Failed! Please check Deployment logs for more informations.."
echo "END CodeDeploy LifeCycle: \"Validate Service\""
