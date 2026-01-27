# log-analytics-demo

A demo combining Amazon Kinesis Data Streams, Amazon Data Firehose and
Amazon Managed Service for Apache Flink running a Zeppelin notebook.

## Installation

This repository is a member of the **Storm Library for Terraform** and
can be built using GitHub Actions. It you want to do so, you need to

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

#### Storm Library for Terraform

This repository is a member of the SLT | Storm Library for Terraform,
a collection of Terraform modules for Amazon Web Services. The focus
of these modules, maintained in separate GitHub™ repositories, is on
building examples, demos and showcases on AWS. The audience of the
library is learners and presenters alike - people that want to know
or show how a certain service, pattern or solution looks like, or "feels".

[Learn more](https://github.com/stormreply/storm-library-for-terraform)

#### Credits

- **Inspiration:** https://d1.awsstatic.com/Projects/P4113850/aws-projects_build-log-analytics-solution-on-aws.pdf
- **Faker:** https://github.com/joke2k/faker
