#!/usr/bin/env bash

build() {
  echo "Building new image"
  docker build -t sec/wannacry-check .
}

run() {
  echo "Running service"
  cid=$(docker run -d -p 127.0.0.1:8080:80 --name wannacry-check sec/wannacry-check:latest)
  echo "Container started with id '${cid}'"

  docker logs -f ${cid}
}

stop() {
  ocid=$(docker ps -a | grep wannacry-check | awk '{print $1}')
  if [[ ! -z ${ocid} ]]; then
    echo "Stopping ${ocid}"
    docker stop ${ocid}
    docker rm ${ocid}
  fi
}

if [[ $# -eq 0 ]]; then
  build
  run
  exit 0
fi

for arg in "$@"; do
  case $arg in
    build)
      build
      ;;
    run)
      run
      ;;
    stop)
      stop
      ;;
    *)
      echo "'build' and / or 'run'"
  esac
done