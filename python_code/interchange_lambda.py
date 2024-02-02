from datetime import datetime
import boto3
import datetime
import time
import os

LOCALSTACK_HOSTNAME = os.environ.get("LOCALSTACK_HOSTNAME", "localhost")
endpoint_url = f"http://{LOCALSTACK_HOSTNAME}:4566"


def process_data():

    logs_client = boto3.client('logs', region_name='us-east-2', endpoint_url=endpoint_url)
    log_message = 'Enable Water Change System'
    logs_client.put_log_events(
        logGroupName='EnableSystem',
        logStreamName='WaterStream',
        logEvents=[
            {
                'message': log_message,
                'timestamp': int(time.time() * 1000)
            },
        ]
    )
    # Update table with th new water_timestamp
    dynamodb_client = boto3.resource('dynamodb', region_name='us-east-2', endpoint_url=endpoint_url)
    details_t = dynamodb_client.Table('Details')
    response = details_t.get_item(Key={'id': 1})
    item = response.get('Item')
    if item:
        water_timestamp = item.get("water_timestamp")
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        water_timestamp.append(timestamp)
        water_timestamp = water_timestamp[-10:]
        details_t.update_item(
            Key={'id': 1},
            UpdateExpression='SET #water_timestamp = :water_timestamp',
            ExpressionAttributeNames={
                '#water_timestamp': 'water_timestamp',
            },
            ExpressionAttributeValues={':water_timestamp': water_timestamp})
        print(f"enable water change system at: {str(timestamp)}")

    # Put a metric in ChangeWater stream in cloudwatch
    cloudwatch_client = boto3.client('cloudwatch', endpoint_url=endpoint_url, region_name='us-east-2')
    cloudwatch_client.put_metric_data(
        Namespace='WaterNameSpace',
        MetricData=[
            {
                'MetricName': 'ChangeWater',
                'Dimensions': [
                    {
                        'Name': 'TableName',
                        'Value': 'Details'
                    },
                ],
                'Unit': 'Count',
                'Value': 1
            },
        ]
    )


def lambda_handler(event, context):
    if 'Records' in event:
        for record in event.get('Records', []):
            if record['eventName'] in ['INSERT', 'MODIFY']:
                data = record['dynamodb']['NewImage']['filtering_timestamp']
                if 'L' in data and isinstance(data['L'], list) and len(data['L']) % 3 == 0:
                    process_data()
    elif 'version' in event:
        process_data()
