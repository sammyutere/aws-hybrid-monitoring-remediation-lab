#!/bin/bash

LOG_FILE="./automation/logs/node_exporter_auto_restart.log"

echo "-----" >> $LOG_FILE
echo "$(date) ALERT RECEIVED - restarting node_exporter" >> $LOG_FILE

INSTANCE_ID=$(cat lab/evidence/day08_instance_id.txt)

aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters commands="sudo systemctl restart node_exporter" \
  --region us-east-1 \
  >> $LOG_FILE

echo "$(date) restart command sent via SSM" >> $LOG_FILE
