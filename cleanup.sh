#!/bin/bash

# Stop and delete containers
if [ $((docker ps -a -q) | wc -l) -eq 0 ] ; then echo "No containers to delete"; else echo "The following container(s) will be deleted: "; docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) ; fi