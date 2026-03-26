# AWS Cost Guardrails

## Instance Types
- t3.micro or t4g.micro only.

## Region
- Use one region consistently to avoid surprise spend.

## Shutdown Policy
- Stop EC2 instances when not actively testing.
- Destroy unused infrastructure with terraform destroy.

## Budget Alert
- Monthly budget: $20.
- Budget + alert configured on Day 2.

## Avoid Cost Traps
- Avoid NAT Gateway unless required.
- Avoid leaving load balancers running.
