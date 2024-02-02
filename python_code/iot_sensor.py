import boto3
import datetime
import random
from decimal import Decimal

from config import DefaultConfig

CONFIG = DefaultConfig()
endpoint_url = f"http://{CONFIG.LOCALSTACK_HOSTNAME}:4566"
details_queueUrl = f"{endpoint_url}/000000000000/details"
pollution_queueUrl = f"{endpoint_url}/000000000000/pollution"


def iot_sensor():

    sqs_client = boto3.client('sqs', region_name='us-east-2', endpoint_url=endpoint_url)
    ph = 7#random.randint(0, 14)
    random_t = 23.6#random.uniform(0.0, 40.0)
    temperature = round(Decimal(str(random_t)), 2)
    hardness = 5#random.randint(0, 15)
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    msg = f'{{"ph": {ph}, "temperature": {temperature}, "hardness": {hardness}, "timestamp": "{timestamp}"}}'
    sqs_client.send_message(QueueUrl=details_queueUrl, MessageBody=msg,
                            MessageAttributes={'date': {'StringValue': str(timestamp), 'DataType': 'String'}})
    if ph < 7 or ph > 8 or temperature < 23 or temperature > 26 or hardness < 3 or hardness > 8:
    	sqs_client.send_message(QueueUrl=pollution_queueUrl, MessageBody=str(timestamp), MessageAttributes={'date': {'StringValue': str(timestamp), 'DataType': 'String'}})


iot_sensor()
