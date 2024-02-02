import boto3
import datetime
import time
import os


LOCALSTACK_HOSTNAME = os.environ.get("LOCALSTACK_HOSTNAME", "localhost")
endpoint_url = f"http://{LOCALSTACK_HOSTNAME}:4566"


def process_data():
    sqs_client = boto3.client('sqs', region_name='us-east-2', endpoint_url=endpoint_url)
    msg = sqs_client.receive_message(QueueUrl=f"{endpoint_url}/000000000000/pollution",
                                     AttributeNames=['All'],
                                     MessageAttributeNames=['date'])
    print(msg.keys())
    if "Messages" in msg.keys():
        sqs_client.delete_message(QueueUrl=f"{endpoint_url}/000000000000/pollution",
                                  ReceiptHandle=msg["Messages"][0]["ReceiptHandle"])
    # Enable filter system with a log in cloudwatch in the log group "EnableSystem" in the stream 'FilteringStream'
    logs_client = boto3.client('logs', region_name='us-east-2', endpoint_url=endpoint_url)
    log_message = 'Enable Filter System'
    logs_client.put_log_events(
        logGroupName='EnableSystem',
        logStreamName=str('FilteringStream'),
        logEvents=[
            {
                'message': log_message,
                'timestamp': int(time.time() * 1000)
            },
        ]
    )
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    dynamodb_client = boto3.resource('dynamodb', region_name='us-east-2', endpoint_url=endpoint_url)
    table = dynamodb_client.Table('Timestamp')
    response = table.get_item(Key={'id': 1})
    if 'Item' in response:
        item = response['Item']
        filtering_timestamp = item.get('filtering_timestamp')
        filtering_timestamp.append(timestamp)
        if len(filtering_timestamp) > 9:
            filtering_timestamp = filtering_timestamp[-7:]
        table.update_item(
            Key={'id': 1},
            UpdateExpression='SET #filtering_timestamp = :filtering_timestamp',
            ExpressionAttributeNames={
                '#filtering_timestamp': 'filtering_timestamp'
            },
            ExpressionAttributeValues={':filtering_timestamp': filtering_timestamp})
        print(f"enable filtering system at: {str(timestamp)}")


def lambda_handler(event, context):
    process_data()
