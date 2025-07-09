#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash cmake inotify-tools gum

STATE="building"
SHOULD_RESTORE_SYSTEMD_UNIT=0

export GUM_CONFIRM_PROMPT_FOREGROUND="7"
export GUM_CONFIRM_SELECTED_FOREGROUND="15"
export GUM_CONFIRM_SELECTED_BACKGROUND="12"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="8"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="15"

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

  if [[ $SHOULD_RESTORE_SYSTEMD_UNIT -eq 1 ]]; then
    log info "Restoring systemd unit..."
    systemctl start --user "desktop-shell.service"
  fi

  exit 0
}

main() {
  trap cleanup SIGINT

  if systemctl is-active --user --quiet "desktop-shell.service"; then 
    gum confirm "An existing systemd unit is already running desktop-shell. Terminate it and restore on exit?"
    local gum_exitcode=$?

    case $gum_exitcode in
      0)
        systemctl stop --user desktop-shell
        SHOULD_RESTORE_SYSTEMD_UNIT=1
        ;;
      1)
        ;;
      *)
        exit $gum_exitcode
        ;;
    esac
  fi

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
}

main
