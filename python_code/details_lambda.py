import json
import boto3
from decimal import Decimal
import os

LOCALSTACK_HOSTNAME = os.environ.get("LOCALSTACK_HOSTNAME", "localhost")
endpoint_url = f"http://{LOCALSTACK_HOSTNAME}:4566"
queueUrl = f"{endpoint_url}/000000000000/details"


def process_data(ph_value, temperature_value, hardness_value, timestamp_value):
    sqs_client = boto3.client('sqs', region_name='us-east-2', endpoint_url=endpoint_url)
    msg = sqs_client.receive_message(QueueUrl=queueUrl,
                                          AttributeNames=['All'],
                                          MessageAttributeNames=['date'])
    new_ph = ph_value
    new_temperature = Decimal(str(temperature_value))
    new_hardness = hardness_value
    new_timestamp = timestamp_value
    if "Messages" in msg.keys():
        message_data = json.loads(msg["Messages"][0]['Body'])
        new_ph = message_data.get('ph')
        new_temperature = Decimal(str(message_data.get('temperature')))
        new_hardness = message_data.get('hardness')
        new_timestamp = message_data.get('timestamp')
        sqs_client.delete_message(QueueUrl=queueUrl,
                                  ReceiptHandle=msg["Messages"][0]["ReceiptHandle"])
    dynamodb_client = boto3.resource('dynamodb', region_name='us-east-2', endpoint_url=endpoint_url)
    table = dynamodb_client.Table('Details')
    response = table.get_item(Key={'id': 1})

    if 'Item' in response:
        item = response['Item']
        ph = item.get('ph')
        temperature = item.get('temperature')
        hardness = item.get('hardness')
        timestamp = item.get('timestamp')
        ph.append(new_ph)
        temperature.append(new_temperature)
        hardness.append(new_hardness)
        timestamp.append(new_timestamp)
        ph = ph[-10:]
        temperature = temperature[-10:]
        hardness = hardness[-10:]
        timestamp = timestamp[-10:]
        table.update_item(
            Key={'id': 1},
            UpdateExpression='SET #ph= :ph, #temperature= :temperature, #hardness= :hardness, #timestamp= :timestamp',
            ExpressionAttributeNames={
                '#ph': 'ph',
                '#temperature': 'temperature',
                '#hardness': 'hardness',
                '#timestamp': 'timestamp'
            },
            ExpressionAttributeValues={':ph': ph, ':temperature': temperature, ':hardness': hardness,
                                       ':timestamp': timestamp})


def lambda_handler(event, context):
    json_body = json.loads(event['Records'][0]['body'])
    ph = json_body['ph']
    temperature = json_body['temperature']
    hardness = json_body['hardness']
    timestamp = json_body['timestamp']
    process_data(ph, temperature, hardness, timestamp)
