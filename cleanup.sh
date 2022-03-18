#!/bin/bash

container=$(docker ps -a --filter "name=my_app" --format '{{.Names}}')

# Stop and delete containers
if [ $((docker ps -a --filter "name=my_app") | wc -l) -eq 0 ] ; then echo "No containers to delete"; else echo "The following container(s) will be deleted: "; docker stop $container && docker rm $container ; fi