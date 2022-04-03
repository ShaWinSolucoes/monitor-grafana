#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Load env file
source $DIR/.env

usage() {
  echo -n "run.sh [OPTION]...

API to perform transactions with chaincodes.

MODE:
    up                      Start clean monitor containers
    down                    Stop the monitor containers
    restart                 Restart the monitor containers

OPTION:
    -h, --help        Display this help and exit
    -b                Rebuild image
"
}

MODE=$1
shift

while getopts "hbc:" OPT; do
  case "${OPT}" in
  h | \?)
    usage
    exit 0
    ;;
  b)
    BUILD=true
    ;;
  c)
    CONTAINERS=${OPTARG}
    ;;

  esac
done

main() {
  setupConfigFiles

  if [ "${MODE}" == "up" ]; then
    down
    up
  elif [ "${MODE}" == "down" ]; then
    down
  elif [ "${MODE}" == "restart" ]; then
    restart
  else
    usage
  fi
}

setupConfigFiles() {
  if [ -z $PORT ]; then
    PORT=3002
  fi

  sed -e 's/PORT/'$PORT'/g' \
    $DIR/grafana/custom-template.ini >$DIR/grafana/custom.ini
}

restart() {
  # If containers wasn't passed, restart all
  [[ -z $CONTAINERS ]] && CONTAINERS='prometheus grafana'

  for CONTAINER in $CONTAINERS; do
    docker stop $CONTAINER

    if [ "$BUILD" = true ]; then
      docker-compose build --no-cache $CONTAINER
    fi

    docker-compose up -d $CONTAINER
  done
}

up() {
  if [ "$BUILD" = true ]; then
    docker-compose build --no-cache
  fi
  docker-compose up -d
}

down() {
  docker-compose down
  docker volume prune -f
}

main
