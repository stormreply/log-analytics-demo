# log-analytics-demo

A demo combining Amazon Kinesis Data Streams, Amazon Data Firehose and
Amazon Managed Service for Apache Flink running a Zeppelin notebook.

#### Storm Library for Terraform

This repository is a member of the SLT | Storm Library for Terraform,
a collection of Terraform modules for Amazon Web Services. The focus
of these modules, maintained in separate GitHub™ repositories, is on
building examples, demos and showcases on AWS. The audience of the
library is learners and presenters alike - people that want to know
or show how a certain service, pattern or solution looks like, or "feels".

[Learn more](https://github.com/stormreply/storm-library-for-terraform)

## Installation

This demo can be built using GitHub Actions. In order to do so

- [Install the Storm Library for Terraform](https://github.com/stormreply/storm-library-for-terraform/blob/main/docs/INSTALL-LIBRARY.md)
- **Only if your account has AWS Lake Formation enabled:**
  - Check the value of the _DEPLOYMENT\_ROLE_ environment variable as shown
    in the summary of the _Apply_ workflow you executed in order to install
    the Storm Library for Terraform. It starts with _slt-0_ and ends with
    _-deployment_.
  - In AWS Lake Formation, open _Administrative roles and tasks_. In the
    section _Database creators_, click on _Grant_
  - In the opening _Grant permissions_ panel, in the _IAM users and roles_
    input, select your deployment role which you fetched before
  - Tick both _Create database_ radio buttons
  - Confirm by clicking _Grant_
- [Deploy this member repository](https://github.com/stormreply/storm-library-for-terraform/blob/main/docs/DEPLOY-MEMBER.md)

Deployment of this member should take < 5 minutes on GitHub resources.

## Architecture

[Image]

## Explore this demo

1. In your GitHub _Apply_ workflow run, click on _Summary_. If you scroll
   down, you will see the _apply / check summary_.
1. Take a look at the _ENVIRONMENT_ variables. Note the _DEPLOYMENT\_NAME_
   environment variable. Its value should match the pattern
   _slt-(some number)-log-analytics-demo-(your github owner)_.
1. From the same page, download the artifact ending on _.zeppelin_ to
   your download folder and unzip it if necessary
1. In the AWS Console, on the Managed Apache Flink service page, click on
   _Studio notebooks_ on the left-hand side menu
1. In the list of _Studio notebooks_ in the center, click on the
   _log-analytics-demo_ notebook that has been created
1. In the view that opens, click on the _Run_ button. You will be asked to
   confirm. Do so by clicking _Run_ once more.
1. A message will appear in your center view, informing you that the service
   is "Starting Studio notebook (your studio notebook)...". Wait until the
   startup process has completed. It may take a few minutes.
1. You will be notified in the AWS Console as soon as your notebook has
   successfully started. Then, click _Open in Apache Zeppelin_.
1. A new browser tab will open, welcoming you to Apache Zeppelin.
1. On that browser page, click _Import note_. A panel titled _Import
   New Note_ will pop up. Click on the area saying _Select JSON File/IPYNB File_
   and choose your unzipped Zeppelin notebook from your download folder.
1. You will notice a new notebook link called _Log Analytics Demo_
   on the refreshed Zeppelin browser page. Click on the link.
1. The _Log Analytics Demo_ notebook will open. Next to its title, find
   a small triangle (like a "play" button) that enables you to run
   all paragraphs one after the other. Click on that play button.
1. The paragraphs will run one after the other. Execution will take
   a minute or two.
1. Check the last paragraph. Don't worry if it's saying _no result data_
   for a minute or so. A pie chart will show up. The pie chart will
   update every ten seconds, showing percentages of HTTP status codes
   sent from an instance running Faker.

## Terraform Docs

<details>
<summary>Click to show</summary>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6 |
| <a name="provider_aws.no_tags"></a> [aws.no\_tags](#provider\_aws.no\_tags) | >= 6 |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | n/a |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_producer"></a> [producer](#module\_producer) | git::https://github.com/stormreply/ssm-managed-instance.git | n/a |

## Resources

| Name | Type |
|------|------|
| [aws\_cloudwatch\_log\_group.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws\_cloudwatch\_log\_stream.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws\_glue\_catalog\_database.hive\_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws\_glue\_catalog\_database.zeppelin\_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws\_iam\_policy.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws\_iam\_policy.zeppelin\_notebook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws\_iam\_role.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws\_iam\_role.zeppelin\_notebook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws\_iam\_role\_policy\_attachment.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws\_iam\_role\_policy\_attachment.zeppelin\_notebook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws\_kinesis\_firehose\_delivery\_stream.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws\_kinesis\_stream.ingestion\_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [aws\_lakeformation\_permissions.hive\_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions) | resource |
| [aws\_lakeformation\_permissions.zeppelin\_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions) | resource |
| [aws\_s3\_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws\_s3\_object.connector\_jar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws\_security\_group.producer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [awscc\_kinesisanalyticsv2\_application.zeppelin\_notebook](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/kinesisanalyticsv2_application) | resource |
| [local\_file.zeppelin\_notebook\_json](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null\_resource.connector\_download](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time\_sleep.iam\_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws\_availability\_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws\_caller\_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws\_iam\_policy.amazon\_kinesis\_firehose\_full\_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws\_iam\_policy.amazon\_kinesis\_full\_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws\_iam\_policy.amazon\_ssm\_managed\_instance\_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws\_iam\_policy.cloudwatch\_full\_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws\_iam\_policy\_document.delivery\_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws\_iam\_policy\_document.delivery\_firehose\_assume\_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws\_iam\_policy\_document.zeppelin\_notebook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws\_iam\_policy\_document.zeppelin\_notebook\_assume\_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws\_iam\_role.caller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws\_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [cloudinit\_config.controller](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [external\_external.lakeformation\_enabled](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__metadata"></a> [\_metadata](#input\_\_metadata) | n/a | <pre>object({<br/>    actor      = string # Github actor (deployer) of the deployment<br/>    catalog_id = string # SLT catalog id of this module<br/>    deployment = string # slt-<catalod_id>-<repo>-<actor><br/>    ref        = string # Git reference of the deployment<br/>    ref_name   = string # Git ref_name (branch) of the deployment<br/>    repo       = string # GitHub short repository name (without owner) of the deployment<br/>    repository = string # GitHub full repository name (including owner) of the deployment<br/>    sha        = string # Git (full-length, 40 char) commit SHA of the deployment<br/>    short_name = string # slt-<catalog_id>-<actor><br/>    time       = string # Timestamp of the deployment<br/>  })</pre> | <pre>{<br/>  "actor": "",<br/>  "catalog_id": "",<br/>  "deployment": "",<br/>  "ref": "",<br/>  "ref_name": "",<br/>  "repo": "",<br/>  "repository": "",<br/>  "sha": "",<br/>  "short_name": "",<br/>  "time": ""<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__default_tags"></a> [\_default\_tags](#output\_\_default\_tags) | n/a |
| <a name="output__metadata"></a> [\_metadata](#output\_\_metadata) | n/a |
| <a name="output__name_tag"></a> [\_name\_tag](#output\_\_name\_tag) | n/a |
| <a name="output_artifact"></a> [artifact](#output\_artifact) | n/a |
<!-- END_TF_DOCS -->

</details>

## Credits

- **Inspiration:** https://d1.awsstatic.com/Projects/P4113850/aws-projects_build-log-analytics-solution-on-aws.pdf
- **Faker:** https://github.com/joke2k/faker
