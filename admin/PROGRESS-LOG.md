# Progress Log

## Day 01 — AWS Bootstrap

### Goal
Establish AWS project baseline and verify credentials.

### Actions Taken
- Created repository structure.
- Verified AWS CLI installation.
- Verified Terraform installation.
- Captured STS identity evidence.
- Defined cost guardrails.

### Evidence
- lab/evidence/day01_sts_identity.json

### Checkpoint
- Tag: day01-bootstrap
- Restore Method:
  - Clone repo
  - Run aws configure
  - Verify with aws sts get-caller-identity


## Day 02 — Budget Guardrails & Terraform Initialization

### Objectives
- Create monthly AWS budget.
- Establish SNS notification channel.
- Initialize Terraform project.

### Actions Taken
- Created SNS topic for alerts.
- Subscribed email to SNS.
- Created $20 monthly budget.
- Initialized Terraform provider.
- Validated Terraform configuration.

### Terraform Execution Model

Terraform is executed via Docker:

Example:

    cd infra/terraform
    ./tf.sh init
    ./tf.sh plan -var="ami_id=<AMI>"

Rationale:
- Avoid macOS binary compatibility issues.
- Ensure consistent version (hashicorp/terraform:1.6.6).
- Improve reproducibility across environments.

### Evidence
- lab/evidence/day02_sns_topics.json
- lab/evidence/day02_budget_config.json
- lab/evidence/day02_terraform_plan.txt

### Checkpoint
- Tag: day02-budget-terraform-baseline
- Restore Method:
  - aws configure
  - terraform init
  - terraform validate

## Day 03 — VPC + EC2 + node_exporter

### Objectives
- Deploy VPC and subnet.
- Launch EC2 instance.
- Install node_exporter automatically.
- Restrict port 9100 to my IP.

### Evidence
- lab/evidence/day03_instance_state.txt
- lab/evidence/day03_node_exporter_head.txt

### Validation
- curl http://<EC2_PUBLIC_IP>:9100/metrics returns metrics.

### Checkpoint
- Tag: day03-vpc-ec2-node-exporter
- Restore Method:
  - ./tf.sh apply with correct vars
  - Verify exporter reachable
