#!/bin/bash
container=maven_container
for rcontainers in $(docker ps | grep $container | awk '{print $1}'); do docker stop $rcontainers; done
for containers in $(docker ps -a | grep $container | awk '{print $1}'); do docker rm $containers; done
for images in $(docker images | grep $image | awk '{print $3}'); do docker rmi $images; done
