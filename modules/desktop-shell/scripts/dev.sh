#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash cmake inotify-tools gum

STATE="building"

if [[ $DEV_DEBUG -eq 1 ]]; then
  set -x
fi

log() {
  local level=$1
  shift

  gum log --time "[2006-01-02T15:04:05Z07:00]" --structured --level "$level" "$@"
}

run() {
  ./build/desktop-shell
  DESKTOPSHELL_EXITCODE=$?

  if [[ $STATE == "running" ]]; then
    log error "\"./build/desktop-shell\" exited with exit code $DESKTOPSHELL_EXITCODE. Waiting for changes before restarting..."
  fi
}

cleanup() {
  STATE="cleanup"

  log info "Exiting..."
  pkill --signal TERM --parent "$$"
  wait "$$" 2>/dev/null
  exit 0
}

trap cleanup SIGINT

while true; do
  STATE="building"
  mkdir -p build

  log info "Building..."
  cmake --build build

  STATE="running"
  run &
  DESKTOPSHELL_PID=$!

  log info "Waiting for changes... (^C to quit)"
  inotifywait --quiet --recursive --event create,modify,delete --exclude '^\./build/' .
  log info "Change detected, restarting..."

  STATE="restarting"
  pkill --signal TERM --parent "$DESKTOPSHELL_PID"
  kill -TERM "$DESKTOPSHELL_PID"
  wait "$DESKTOPSHELL_PID"
done
