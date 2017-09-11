# [swagger-bundler](https://github.com/networknt/swagger-bundler)

Dockerfile for running Swagger Bunlder.

This allows users to bundle multiple YAML files together into one self-contained file
as input for light-codegen. By using docker, you don't need to clone and build locally.

To build docker image and push it to docker hub, you have to make sure that there
is no existing image on your build server. If there are some older version of
light-codegen, you need to remove them using 

```
docker rmi -f imageId
```

And then run build.sh with a version number as the parameter.

```
./build.sh 0.1.1
```
