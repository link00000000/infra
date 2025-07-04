#!/usr/bin/env bash

start_process() {
  setsid ags run app.ts &
  PID=$!
}

stop_process() {
  if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
    kill -TERM -"$PID"
    wait "$PID"
  fi
}

trap stop_process SIGINT

start_process

while inotifywait --quiet --event modify --event create --event delete --recursive .; do
  echo "File change detected. Restarting..."
  stop_process
  start_process
done
