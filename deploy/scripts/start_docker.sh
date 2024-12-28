#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 225989338339.dkr.ecr.ap-southeast-2.amazonaws.com

echo "Pulling Docker image..."
docker pull 225989338339.dkr.ecr.ap-southeast-2.amazonaws.com/swiggy_delivery_time_pred:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=swiggy_delivery_time_pred)" ]; then
    echo "Stopping existing container..."
    docker stop swiggy_delivery_time_pred
fi

if [ "$(docker ps -aq -f name=swiggy_delivery_time_pred)" ]; then
    echo "Removing existing container..."
    docker rm swiggy_delivery_time_pred
fi

echo "Starting new container..."
docker run -d -p 80:8000 --name swiggy_delivery_time_pred -e DAGSHUB_USER_TOKEN=235f33b3db0e9371ca3b238cabb9c6fec2ee4bb4 225989338339.dkr.ecr.ap-southeast-2.amazonaws.com/swiggy_delivery_time_pred:latest

echo "Container started successfully."