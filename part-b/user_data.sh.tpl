#!/bin/bash
yum update -y
yum install -y nc
yum install -y docker
yum install -y mysql
service docker start
docker run -d \
    -p 8080:80 \
    --name my-nginx \
    -e DB_USER=${db_username} \
    -e DB_PASSWORD=${db_password} \
    -e DB_HOST=${db_host} \
    -e DB_NAME=${db_name} \
    nginx:1.25.2
