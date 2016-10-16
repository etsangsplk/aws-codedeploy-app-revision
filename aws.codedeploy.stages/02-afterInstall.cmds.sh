#!/bin/bash

die() {
    echo "FATAL ERROR: $* (status $?)" 1>&2
    echo "Aborting Deployment.." 1>&2
    exit 1
}

echo "## START CodeDeploy LifeCycle: \"After Install\""
    bash /aws.services/codedeploy/aws-ec2-instance-provision-scripts/execute.after-install.cmds.sh || die "Execution of a Command Failed! Please check Deployment logs for more informations.."
echo "## END CodeDeploy LifeCycle: \"After Install \""
