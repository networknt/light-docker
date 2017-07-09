# [light-codegen](https://github.com/networknt/light-codegen)

Dockerfile for running Light Codegen.

This allows users to generate code without cloning/building light-codegenJava on 
the host machine. It is also helpful if you can't, or don't want to, install Bash 
in your environment.

To build docker image and push it to docker hub, you have to make sure that there
is no existing image on your build server. If there are some older version of
light-codegen, you need to remove them using 

```
docker rmi -f imageId
```

And then run build.sh with a version number as the parameter.

```
./build.sh 1.3.4
```
