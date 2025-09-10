#!/bin/bash

deployment_name=$1

echo "BEGIN -- 02-install-kinesis-agent.sh"

sudo yum update -y
sudo yum install git -y
sudo yum install python3-pip -y
sudo yum install aws-kinesis-agent -y

mkdir -p /apache/logs

cat << EOT > /etc/aws-kinesis/agent.json
{
"kinesis.endpoint": "kinesis.eu-central-1.amazonaws.com",
"flows": [
    {
        "filePattern": "/apache/logs/_access_log_*.log",
        "kinesisStream": "${deployment_name}-ingestion-stream",
        "dataProcessingOptions": [
            {
            "optionName": "LOGTOJSON",
            "logFormat": "COMBINEDAPACHELOG"
            }
        ],
        "maxBufferAgeMillis": 10000
    }
]
}
EOT

service aws-kinesis-agent start

echo "END ---- 02-install-kinesis-agent.sh"
