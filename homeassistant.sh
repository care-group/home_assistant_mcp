#!/bin/bash

# Change these if needed
CONTAINER_NAME="homeassistant"
IMAGE_NAME="linuxserver/homeassistant:latest"
CONFIG_DIR="$HOME/homeassistant/config"
TZ="Europe/London"
PUID=1000
PGID=1000

case "$1" in
  start)
    echo "Starting Home Assistant container..."
    sudo docker run -d \
      --name=$CONTAINER_NAME \
      --network=host \
      -e PUID=$PUID -e PGID=$PGID \
      -e TZ=$TZ \
      -v $CONFIG_DIR:/config \
      $IMAGE_NAME
    ;;
  
  stop)
    echo "Stopping Home Assistant container..."
    sudo docker stop $CONTAINER_NAME
    ;;
  
  restart)
    echo "Restarting Home Assistant container..."
    sudo docker restart $CONTAINER_NAME
    ;;
  
  remove)
    echo "Stopping and removing Home Assistant container..."
    sudo docker stop $CONTAINER_NAME
    sudo docker rm $CONTAINER_NAME
    ;;
  
  logs)
    echo "Showing logs for Home Assistant container..."
    sudo docker logs -f $CONTAINER_NAME
    ;;
  
  status)
    echo "Checking Home Assistant container status..."
    sudo docker ps -a | grep $CONTAINER_NAME
    ;;
  
  *)
    echo "Usage: $0 {start|stop|restart|remove|logs|status}"
    exit 1
    ;;
esac
