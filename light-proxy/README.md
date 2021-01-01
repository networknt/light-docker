This folder contains configuration folders for different utilization with light-proxy to build docker images. 

### aws-lambda

Deploy the light-proxy to the AWS and proxy to the Lambda funcations with all the cross-cutting concerns addressed. It is to replace the API Gateway as the entry point for the Lambda functions. 

The openapi.yaml is from the petstore from model-config/rest/openapi/petstore folder and the lambda is generated from model-config/lambda/petstore

