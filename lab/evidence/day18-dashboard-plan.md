# Day 18 Dashboard Plan

## Dashboard Title
AWS Hybrid Reliability Overview

## Panels

1. Current exporter reachability
   Query: up{job="aws-node"}

2. SLI ratio (5m)
   Query: job:aws_node:up:ratio_5m

3. SLI ratio (1h)
   Query: job:aws_node:up:ratio_1h

4. SLO ratio (24h)
   Query: job:aws_node:up:ratio_24h

5. Error budget remaining (24h)
   Query: job:aws_node:error_budget_remaining_24h

6. Burn rate (5m)
   Query: job:aws_node:burn_rate_5m

7. Burn rate (1h)
   Query: job:aws_node:burn_rate_1h

8. Active SLO and burn-rate alerts
   Query: ALERTS{alertname=~"AwsNodeSLOBreaching|AwsNodeFastBurnCritical|AwsNodeBurnRateHigh|AwsNodeBurnRateSlow"}
