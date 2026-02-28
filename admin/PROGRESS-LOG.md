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

## Day 04 — Local Prometheus Scraping AWS

### Objectives
- Run Prometheus locally via Docker.
- Scrape EC2 node_exporter.
- Run Alertmanager locally.
- Validate metrics ingestion.

### Validation
- Prometheus UI reachable.
- Target status shows UP.
- Query `up` returns 1.
- Alertmanager ready endpoint returns success.

### Evidence
- lab/evidence/day04_prometheus_ready.txt
- lab/evidence/day04_prometheus_targets.json
- lab/evidence/day04_node_exporter_head.txt
- lab/evidence/day04_up_query.json
- lab/evidence/day04_alertmanager_ready.txt

### Checkpoint
- Tag: day04-local-monitoring-baseline
- Restore Method:
  - Ensure EC2 running.
  - Start Prometheus Docker container.
  - Start Alertmanager Docker container.
  - Verify target status UP.

## Day 05 — First Alert Rule + Failure Drill (NodeExporterDown)

### Objectives
- Add NodeExporterDown alert rule.
- Validate rule loading in Prometheus.
- Validate alert delivery to Alertmanager.
- Run a controlled failure drill.

### What I changed
- Added Prometheus rule group `node-basic` with alert `NodeExporterDown`.
- Configured Prometheus to send alerts to local Alertmanager via host.docker.internal.

### Architectural Improvement — Elastic IP

Problem:
- EC2 public IP changed after Terraform apply.
- Prometheus target no longer resolved.

Root Cause:
- Instance used ephemeral public IP.
- Infrastructure was not stable for monitoring endpoint.

Solution:
- Allocated Elastic IP via Terraform.
- Associated EIP with monitoring node.
- Updated Prometheus scrape target to use Elastic IP.
- Verified metrics reachable and target status UP.

Operational Benefit:
- Monitoring endpoint now stable across instance restart/redeploy.
- Aligns with production best practices.

### Failure Drill Method
- Simulated exporter reachability failure by temporarily changing Security Group ingress to a wrong my_ip/32.
- Restored my_ip/32 afterward to resolve alert.

### Evidence
- lab/evidence/day05_prometheus_ready.txt
- lab/evidence/day05_eip_output.txt
- lab/evidence/day05_rules.json
- lab/evidence/day05_alertmanager_ready.txt
- lab/evidence/day05_my_ipv4.txt
- lab/evidence/day05_prometheus_alerts_during_outage.json
- lab/evidence/day05_alertmanager_alerts_during_outage.json
- lab/evidence/day05_prometheus_alerts_after_restore.json
- lab/evidence/day05_prometheus_targets_after_restore.json

### Checkpoint
- Tag: day05-alerting-baseline
- Restore Method:
  - Start local Prometheus + Alertmanager containers
  - Ensure SG my_ip/32 matches current IPv4
  - Verify Prometheus target UP and no page alerts firing


## Day 06 — Reproducibility Hardening (EIP + SG lifecycle + Docker Compose)

### Objectives
- Stabilize EC2 monitoring endpoint using Elastic IP (avoid ephemeral public IP drift).
- Prevent Terraform Security Group deletion failures (DependencyViolation).
- Standardize Terraform variable inputs via terraform.tfvars.
- Standardize local monitoring lifecycle via docker compose.

### What I changed
- Terraform:
  - Added/verified Elastic IP + output (stable scrape endpoint).
  - Added `lifecycle { create_before_destroy = true }` to security group to prevent SG deletion while attached.
  - Used `trimspace(var.my_ip)` for CIDR input robustness.
  - Standardized runs with `-var-file=terraform.tfvars`.
- Monitoring:
  - Created `monitoring/docker-compose.yml` to run Prometheus + Alertmanager locally.
  - Updated Prometheus scrape target to use the Elastic IP.

### Evidence
- lab/evidence/day06_tf_plan.txt
- lab/evidence/day06_elastic_ip.txt
- lab/evidence/day06_node_exporter_head_via_eip.txt
- lab/evidence/day06_prometheus_ready.txt
- lab/evidence/day06_alertmanager_ready.txt
- lab/evidence/day06_targets.json
- lab/evidence/day06_rules.json

### Checkpoint (Snapshot Equivalent)
- Tag: day06-reproducibility-baseline
- Restore Method:
  - Terraform: `cd infra/terraform && ./tf.sh apply -var-file=terraform.tfvars`
  - Monitoring: `cd monitoring && docker compose up -d`
  - Validate:
    - Prometheus ready: http://localhost:9090/-/ready
    - Alertmanager ready: http://localhost:9093/-/ready
    - Target health is UP: http://localhost:9090/targets

