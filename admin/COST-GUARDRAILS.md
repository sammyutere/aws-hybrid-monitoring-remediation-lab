# AWS Cost Guardrails

## Instance Types
- t3.micro or t4g.micro only.

## Regions
- us-east-1 (lowest cost baseline).

## Shutdown Policy
- Stop EC2 instances when not actively testing.
- No NAT Gateway unless required.

## Budget Alert
- Monthly budget: $20.
- SNS alert configured on Day 2.

## Monitoring Discipline
- Use free tier where possible.
- Destroy unused infrastructure with terraform destroy.
