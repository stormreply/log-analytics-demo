#!/bin/bash

echo "BEGIN -- 01-stop-ssm-agent.sh"

# NOTE: below suggestion usually not needed, but ssm agent seems
# to claim the rpm lock, forcing other yum installs to fail. see
# https://repost.aws/questions/QUgNz4VGCFSC2TYekM-6GiDQ/dnf-yum-both-fails-while-being-executed-on-instance-bootstrap-on-amazon-linux-2023

systemctl stop amazon-ssm-agent
sleep 5

echo "END ---- 01-stop-ssm-agent.sh"
