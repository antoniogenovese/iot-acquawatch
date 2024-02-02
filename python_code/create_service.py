import boto3
import zipfile

from config import DefaultConfig

CONFIG = DefaultConfig()
endpoint_url = f"http://{CONFIG.LOCALSTACK_HOSTNAME}:4566"


def create_table():

    dynamodb_client = boto3.resource('dynamodb', endpoint_url=endpoint_url, region_name='us-east-2')
    dynamodb_client.create_table(
        TableName=str(CONFIG.TIMESTAMP_TABLE),
        KeySchema=[
            {
                'AttributeName': 'id',
                'KeyType': 'HASH'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'id',
                'AttributeType': 'N'
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 15,
            'WriteCapacityUnits': 15
        },
        StreamSpecification={
            'StreamEnabled': True,
            'StreamViewType': 'NEW_IMAGE'
        }
    )
    dynamodb_client.create_table(
        TableName=str(CONFIG.DETAILS_TABLE),
        KeySchema=[
            {
                'AttributeName': 'id',
                'KeyType': 'HASH'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'id',
                'AttributeType': 'N'
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 15,
            'WriteCapacityUnits': 15
        }
    )


def put_item():

    dynamodb_client = boto3.resource('dynamodb', endpoint_url=endpoint_url, region_name='us-east-2')
    details_t = dynamodb_client.Table(CONFIG.DETAILS_TABLE)
    timestamp_t = dynamodb_client.Table(CONFIG.TIMESTAMP_TABLE)
    timestamp = []
    filtering_timestamp = []
    water_timestamp = []
    ph = []
    temperature = []
    hardness = []
    item = {
        'id': 1,
        'water_timestamp': water_timestamp,
        'ph': ph,
        'temperature': temperature,
        'hardness': hardness,
        'timestamp': timestamp
    }
    details_t.put_item(Item=item)
    item = {
        'id': 1,
        'filtering_timestamp': filtering_timestamp,
    }
    timestamp_t.put_item(Item=item)


def create_lambda_function(function_name):

    lambda_client = boto3.client('lambda', region_name='us-east-2', endpoint_url=endpoint_url)
    with zipfile.ZipFile(f"{function_name}.zip", 'w') as file_zip:
        file_zip.write(f"{function_name}.py", compress_type=zipfile.ZIP_DEFLATED)
    with open(f'{function_name}.zip', 'rb') as f:
        zip_content = f.read()
    timeout_seconds = 200
    environment_variables = {
        'LAMBDA_RUNTIME_ENVIRONMENT_TIMEOUT': str(timeout_seconds)
    }
    iam_client = boto3.client('iam', region_name='us-east-2', endpoint_url=endpoint_url)
    response = iam_client.get_role(RoleName=CONFIG.LAMBDA_ROLE)
    iam_role_arn = response['Role']['Arn']
    response = lambda_client.create_function(
        FunctionName=function_name,
        Runtime='python3.8',
        Role=iam_role_arn,
        Handler=f'{function_name}.lambda_handler',
        Code={
            'ZipFile': zip_content
        },
        Environment={'Variables': environment_variables},
        Timeout=10
    )
    return response['FunctionArn']


def create_log_group():

    logs_client = boto3.client('logs', region_name='us-east-2', endpoint_url=endpoint_url)
    logs_client.create_log_group(logGroupName=CONFIG.LOG_GROUP)
    logs_client.create_log_stream(logGroupName=CONFIG.LOG_GROUP, logStreamName=CONFIG.LOG_FILTER_STREAM)
    logs_client.create_log_stream(logGroupName=CONFIG.LOG_GROUP, logStreamName=CONFIG.LOG_INTERCHANGE_STREAM)


def create_cloudwatch_alarm():

    cloudwatch_client = boto3.client('cloudwatch', region_name='us-east-2', endpoint_url=endpoint_url)
    sns_client = boto3.client('sns', region_name='us-east-2', endpoint_url=endpoint_url)
    response = sns_client.create_topic(Name=CONFIG.SNS_TOPIC)
    topic_arn = response['TopicArn']
    sns_client.subscribe(
        TopicArn=topic_arn,
        Protocol='email',
        Endpoint=CONFIG.EMAIL,
    )
    cloudwatch_client.put_metric_alarm(
        AlarmName='WaterAlarm',
        ComparisonOperator='GreaterThanThreshold',
        EvaluationPeriods=1,
        MetricName=CONFIG.METRIC_NAME,
        Namespace=CONFIG.METRIC_NAMESPACE,
        Period=600,
        Statistic='Sum',
        Threshold=3.0,
        ActionsEnabled=True,
        AlarmActions=[topic_arn],
        Unit="Count",
        Dimensions=[{'Name': CONFIG.DIMENSION_NAME, 'Value': CONFIG.DIMENSION_VALUE}]
    )


def create_stream_lambda_trigger():

    dynamodb_client = boto3.client('dynamodb', region_name='us-east-2', endpoint_url=endpoint_url)
    lambda_client = boto3.client('lambda', region_name='us-east-2', endpoint_url=endpoint_url)
    table_description = dynamodb_client.describe_table(TableName=CONFIG.TIMESTAMP_TABLE)
    stream_arn = table_description['Table']['LatestStreamArn']
    lambda_client.create_event_source_mapping(
        EventSourceArn=stream_arn,
        FunctionName=CONFIG.INTERCHANGE_FUNCTION_NAME,
        StartingPosition='LATEST',
    )


def create_cloudwatch_event(function_arn):

    event_bridge_client = boto3.client('events', region_name='us-east-2', endpoint_url=endpoint_url)
    lambda_client = boto3.client('lambda', region_name='us-east-2', endpoint_url=endpoint_url)
    cron_timestamp = '15 8 1 * ? *'
    response_rule = event_bridge_client.put_rule(
        Name='my-rule',
        ScheduleExpression=f'cron({cron_timestamp})',
        State='ENABLED',
    )

    dynamodb_client = boto3.resource('dynamodb', region_name='us-east-2', endpoint_url=endpoint_url)
    table = dynamodb_client.Table(CONFIG.DETAILS_TABLE)
    response = table.get_item(Key={'id': 1})
    if 'Item' in response:
        table.update_item(
            Key={'id': 1},
            UpdateExpression='SET #cron_timestamp = :cron_timestamp',
            ExpressionAttributeNames={
                '#cron_timestamp': 'cron_timestamp'
            },
            ExpressionAttributeValues={':cron_timestamp': cron_timestamp})

    event_bridge_client.put_targets(
        Rule='my-rule',
        EventBusName='default',
        Targets=[
            {
                'Id': '1',
                'Arn':  function_arn,
            },
        ]
    )
    rule_arn_event = response_rule['RuleArn']

    lambda_client.add_permission(
        FunctionName='interchange_lambda',
        SourceArn=rule_arn_event,
        Action='lambda:InvokeFunction',
        Principal='events.amazonaws.com',
        StatementId='ID1'
    )


def create_sqs_lambda_trigger(function_name, sqs_name):

    lambda_client = boto3.client('lambda', endpoint_url=endpoint_url, region_name='us-east-2')
    response = lambda_client.get_function(FunctionName=function_name)
    function_arn = response['Configuration']['FunctionArn']
    sqs_client = boto3.client('sqs', region_name='us-east-2', endpoint_url=endpoint_url)
    sqs_url = f"{endpoint_url}/000000000000/{sqs_name}"
    sqs_attributes = sqs_client.get_queue_attributes(QueueUrl=sqs_url, AttributeNames=['QueueArn'])
    sqs_arn = sqs_attributes['Attributes']['QueueArn']

    lambda_client.create_event_source_mapping(
        EventSourceArn=sqs_arn,
        FunctionName=function_arn,
        Enabled=True
    )


def create_api_gateway():

    api_gateway_client = boto3.client('apigateway', region_name='us-east-2', endpoint_url=endpoint_url)
    lambda_client = boto3.client('lambda', endpoint_url=endpoint_url, region_name='us-east-2', )

    api_name = 'api_gateway_filtering'
    api_response = api_gateway_client.create_rest_api(name=api_name)
    api_id = api_response['id']

    response = api_gateway_client.get_resources(restApiId=api_id)

    resources = response.get('items', [])
    parent_id = resources[0].get('id')

    resource_response = api_gateway_client.create_resource(
        restApiId=api_id,
        parentId=parent_id,
        pathPart='api_resource'
    )
    resource_id = resource_response['id']

    api_gateway_client.put_method(
        restApiId=api_id,
        resourceId=resource_id,
        httpMethod='POST',
        authorizationType='NONE',
    )

    api_gateway_client.put_integration(
        restApiId=api_id,
        resourceId=resource_id,
        httpMethod='POST',
        type='AWS_PROXY',
        integrationHttpMethod='POST',
        uri='arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:000000000000:function:filtering_lambda/invocations',
    )

    api_gateway_client.create_deployment(
        restApiId=api_id,
        stageName='dev',
    )

    lambda_client.add_permission(
        FunctionName=CONFIG.FILTERING_FUNCTION_NAME,
        StatementId='apigateway',
        Action='lambda:InvokeFunction',
        Principal='apigateway.amazonaws.com',
        SourceArn=f'arn:aws:execute-api:us-east-2:000000000000:{api_id}/*/*',
    )

    invoke_url = f'{endpoint_url}/restapis/{api_id}/dev/_user_request_/api_resource'
    print(f'Invoke URL: {invoke_url}')


create_table()
put_item()
create_lambda_function(CONFIG.FILTERING_FUNCTION_NAME)
create_lambda_function(CONFIG.DETAILS_FUNCTION_NAME)
arn = create_lambda_function(CONFIG.INTERCHANGE_FUNCTION_NAME)
create_log_group()
create_cloudwatch_alarm()
create_stream_lambda_trigger()
create_sqs_lambda_trigger(CONFIG.FILTERING_FUNCTION_NAME, CONFIG.SQS_POLLUTION)
create_sqs_lambda_trigger(CONFIG.DETAILS_FUNCTION_NAME, CONFIG.SQS_DETAILS)
create_cloudwatch_event(arn)
create_api_gateway()

