#!/bin/bash

if [[ $# != 2 ]]
then
  echo 'This script takes exactly 2 argument'
  echo 'Usage: ./ghost $ENV_FILE_PATH CMD'
  exit 1
fi

ENV_FILE=$1
CMD=$2

if [[ ! -f $ENV_FILE ]]
then
	echo "EXITING: $ENV_FILE not found!"
  exit 1
fi

if [[ ( "$CMD" != "start"  && "$CMD" != "stop" && "$CMD" != "restart") ]]
then
	echo "EXITING: $CMD command is not supported!"
  exit 1
fi


# Loading environment variables
echo "Sourcing $ENV_FILE"
source $ENV_FILE

echo "Deploying Ghost with the following configuration:"
echo "Blog URL: $GHOST_BLOG_URL"
echo "MySQL user password: $GHOST_DB_CONN_PASSWORD"
echo "MySQL root password: $MARIADB_ROOT_PASSWORD"
echo "Ghost host data folder: $GHOST_CONTENT_PATH"
echo "MySQL host data folder: $MARIADB_DATA_PATH"
echo "Nginx host config folder: $NGINX_CONF_PATH"
echo "HTTP port: $NGINX_HTTP_PORT"
echo "HTTPS port: $NGINX_HTTPS_PORT"

read -p "Are sure to continue? (Y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "ABORTING..."
  exit 1
fi

echo "Creating host folders..."
if [[ ! -d ./ghost ]]
then
  mkdir -p ./ghost
fi    
if [[ ! -d ./mariadb-data ]]
then
  mkdir -p ./mariadb-data
fi    

pushd blog/ > /dev/null

case $CMD in

  start)
    echo "starting..."
    docker-compose up -d 
  ;;

  stop)
    echo "stopping..."
    docker-compose down
  ;;

  restart)
    echo "restarting..."  
    docker-compose restart
  ;;

  *)
    echo "Unsupported command!"
  ;;
esac

exit 0
