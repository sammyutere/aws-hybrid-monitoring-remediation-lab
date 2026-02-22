import json
import boto3

ssm = boto3.client("ssm")

def handler(event, context):
    print("Received event:", json.dumps(event))
    return {"status": "ok"}
