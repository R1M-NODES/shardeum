#!/bin/bash

while true; do
  #run
  date=$(date '+%Y/%m/%d %H:%M:%S')
  container_name="shardeum-validator"
  status=$(docker exec -it $container_name operator-cli status | awk '/state:/ {print $NF}' 2>/dev/null)
  
  if [[ -z "$status" ]]; then
    echo "Error: Container $container_name not found or operator-cli is not accessible."
    exit 1
  fi
  
  echo "Node status: $status"
  if [[ "$status" == *"top"* ]]; then
    echo "Your node stopped and I am trying to start now: $date"
    sleep 2
    docker exec -it $container_name operator-cli start
    sleep 10
    status=$(docker exec -it $container_name operator-cli status | awk '/state:/ {print $NF}')
    echo "Node status: $status"
  else
    sleep 1
  fi
  #wait
  sleep 600
done
