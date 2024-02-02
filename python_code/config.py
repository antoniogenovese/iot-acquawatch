import os


class DefaultConfig:

    DIMENSION_NAME = os.environ.get('DIMENSION_NAME', 'TableName')
    DIMENSION_VALUE = os.environ.get('DIMENSION_VALUE', 'Details')
    EMAIL = os.environ.get('EMAIL', 'your.email@example.com')
    LOCALSTACK_HOSTNAME = os.environ.get("LOCALSTACK_HOSTNAME", "localhost")
    INTERCHANGE_FUNCTION_NAME = os.environ.get('INTERCHANGE_FUNCTION_NAME', 'interchange_lambda')
    DETAILS_FUNCTION_NAME = os.environ.get('DETAILS_FUNCTION_NAME', 'details_lambda')
    FILTERING_FUNCTION_NAME = os.environ.get('FILTERING_FUNCTION_NAME', 'filtering_lambda')
    LOG_GROUP = os.environ.get('LOG_GROUP', 'EnableSystem')
    LOG_FILTER_STREAM = os.environ.get('LOG_FILTER_STREAM', 'FilteringStream')
    LOG_INTERCHANGE_STREAM = os.environ.get('LOG_INTERCHANGE_STREAM', 'WaterStream')
    METRIC_NAME = os.environ.get('METRIC_NAME', 'ChangeWater')
    METRIC_NAMESPACE = os.environ.get('METRIC_NAMESPACE', 'WaterNameSpace')
    SNS_TOPIC = os.environ.get('SNS_TOPIC', 'SnsTopic')
    TIMESTAMP_TABLE = os.environ.get('TIMESTAMP_TABLE', 'Timestamp')
    DETAILS_TABLE = os.environ.get('DETAILS_TABLE', 'Details')
    SQS_POLLUTION = os.environ.get('SQS_POLLUTION', 'pollution')
    SQS_DETAILS = os.environ.get('SQS_DETAILS', 'details')
    LAMBDA_ROLE = os.environ.get('LAMBDA_ROLE', 'lambda_role')
