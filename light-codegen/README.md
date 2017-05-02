# [swagger-codegen](https://github.com/networknt/light-docker/tree/master/swagger-codegen)

Dockerfile for running Swagger Codegen.

This allows users to generate code without installing Java on the host machine. It is also 
helpful if you can't, or don't want to, install Bash in your environment.

## Options

Swagger Codegen CLI options are available:

* generate
* help
* langs
* meta
* config-help

The default is `help`.

## Usage

All options for the CLI are supported.

```
docker run -it networknt/swagger-codegen config-help -l light-java
```

For full options details, see the [Swagger Codegen README](https://github.com/swagger-api/swagger-codegen).

## Output Folder

Mount a volume to `/swagger-api/out` for output.

Example:

```
docker run -it -v ~/temp/swagger-generated:/swagger-api/out \
    networknt/swagger-codegen generate \
    -i /swagger-api/yaml/petstore-with-fake-endpoints-models-for-testing.yaml \
    -l light-java \
    -o /swagger-api/out/petstore
```
Your generated code will now be accessible under `~/temp/swagger-generated/petstore`.

## Input Swagger Definition

To read in a swagger definition from a local file, just map a volume to `/swagger-api/yaml`.

Example:

```
docker run -it -v ~/temp/swagger-generated:/swagger-api/out \
    -v ~/temp/swagger-definitions:/swagger-api/yaml \
    networknt/swagger-codegen generate \
    -i /swagger-api/yaml/twitter.yaml \
    -l light-java \
    -o /swagger-api/out/twitter
```
Your generated code will now be accessible under `~/temp/swagger-generated/twitter`.
