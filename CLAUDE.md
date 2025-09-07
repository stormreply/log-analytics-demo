# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a log analytics demonstration project that implements AWS log ingestion and processing pipeline based on the AWS tutorial "Build a Log Analytics Solution". It creates an end-to-end system for generating, streaming, and storing Apache log data using AWS services.

## Architecture Components

The infrastructure consists of several key components deployed via Terraform:

1. **Log Generation**: EC2 instance (`log-producer-ec2.tf`) running Apache fake log generator (`apache-fake-log-gen.py`)
2. **Data Ingestion**: Kinesis Data Streams (`ingestion-stream.tf`) for real-time log streaming
3. **Data Delivery**: Kinesis Data Firehose (`delivery-firehose.tf`) for batch delivery to S3
4. **Storage**: S3 bucket (`module-bucket.tf`) with time-partitioned structure
5. **Analytics**: Apache Zeppelin notebook (`zeppelin-notebook.tf`) for data analysis
6. **Authentication**: Cognito setup (`cognito-setup.tf`) for Kinesis Data Generator access

## Deployment

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed
- SSH key pair for EC2 access

### Core Variables
Required variables in `_variables.tf`:
- `bucket_name`: S3 bucket name for log storage
- `os_password`: OpenSearch password (if using OpenSearch destination)
- `private_key_file`: Path to SSH private key for EC2 access
- `cognito_username`: Username for Kinesis Data Generator Cognito user
- `cognito_password`: Password for Kinesis Data Generator Cognito user (sensitive)
- `permissions_boundary_arn`: Optional IAM permissions boundary (defaults to empty)

### Deployment Commands
```bash
# Initialize Terraform
terraform init

# Plan deployment (will prompt for required variables)
terraform plan

# Deploy infrastructure (includes Cognito setup)
terraform apply

# Destroy infrastructure when done
terraform destroy
```

The Cognito setup is now fully integrated into Terraform via `cognito-setup.tf` - no separate CloudFormation deployment needed.

## Key Files

- **apache-fake-log-gen.py**: Python script that generates realistic Apache log entries with configurable output formats (CLF/ELF), supports writing to files, gzip, or console
- **cognito-setup.tf**: Terraform translation of the original CloudFormation template, creates Cognito User Pool, Identity Pool, and IAM roles for Kinesis Data Generator access
- **deployment.tf**: Contains deployment metadata structure for tracking Git references and deployment information
- **log-producer-iam.tf**: IAM roles and policies for EC2 log producer to write to Kinesis streams
- **opensearch-domain.tf.txt**: OpenSearch domain configuration (currently commented out in favor of S3-only pipeline)

## Data Flow

1. EC2 instance generates fake Apache logs using `apache-fake-log-gen.py`
2. AWS Kinesis Agent on EC2 reads log files and streams to Kinesis Data Streams
3. Kinesis Data Firehose consumes from stream and delivers to S3 with time-based partitioning
4. Data stored in S3 with structure: `data/year=YYYY/month=MM/day=DD/hour=HH/`
5. Zeppelin notebook connects to S3 for analytics and visualization

## Known Issues

- Zeppelin notebook redeployment has a bug with the terraform-provider-awscc (see GitHub issue #954)
- OpenSearch integration is currently commented out in delivery-firehose.tf
- The Kinesis Agent service start is commented out in the EC2 user data

## Log Generator Usage

The `apache-fake-log-gen.py` script supports various options:
- `-n <num>`: Number of log lines (0 for infinite)
- `-o <type>`: Output type (LOG, GZ, CONSOLE)
- `-l <format>`: Log format (CLF, ELF)
- `-p <prefix>`: File prefix
- `-s <seconds>`: Sleep between lines
