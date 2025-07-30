#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash cmake inotify-tools gum

if [[ $DEV_DEBUG -eq 1 ]]; then
    set -x
fi

export GUM_CONFIRM_PROMPT_FOREGROUND="7"
export GUM_CONFIRM_SELECTED_FOREGROUND="15"
export GUM_CONFIRM_SELECTED_BACKGROUND="12"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="8"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="15"

FIFO_PATH=.tmp/dev-script-signal

STATE="building"
SHOULD_RESTORE_SYSTEMD_UNIT=0

log() {
    local level=$1
    shift

    gum log --time "[2006-01-02T15:04:05Z07:00]" --structured --level "$level" "$@"
}

setup() {
    STATE="setup"

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
}

run() {
    STATE="building"
    mkdir -p build

    log info "Building..."
    cmake --build build -G Ninja
    CMAKE_EXITCODE=$?

    if [[ $CMAKE_EXITCODE -eq 0 ]]; then
        STATE="running"

        ./build/desktop-shell
        DESKTOPSHELL_EXITCODE=$?

        if [[ $STATE == "running" ]]; then
            log error "\"./build/desktop-shell\" exited with exit code $DESKTOPSHELL_EXITCODE."
        fi
    else
        log error "\"cmake --build build\" exited with exit code $CMAKE_EXITCODE."
    fi
}

restart() {
    STATE="restarting"
    pkill --signal TERM --parent "$PID"
    kill -TERM "$PID"
    wait "$PID"
}

cleanup() {
    STATE="cleanup"

    log info "Exiting..."
    echo "$$" | xargs -I{} pkill --signal TERM --parent {}
    wait "$$" 2>/dev/null

    if [[ -p "$FIFO_PATH" ]]; then
        rm "$FIFO_PATH"
    fi

    if [[ $SHOULD_RESTORE_SYSTEMD_UNIT -eq 1 ]]; then
        log info "Restoring systemd unit..."
        systemctl start --user "desktop-shell.service"
    fi

    exit 0
}

# @cmd Watch for file changes
watch() {
    setup

    while true; do
        run &
        PID=$!

        log info "Watching for changes... (^C to quit)"
        inotifywait --quiet --recursive --event create,modify,delete --exclude '^\./build/' .
        log info "Change detected, restarting..."

        restart
    done
}

# @cmd Wait for signal
# @alias    wait
wait-signal() {
    setup

    mkdir -p "$(dirname $FIFO_PATH)"
    if [[ ! -p "$FIFO_PATH" ]]; then
        mkfifo "$FIFO_PATH"

        while true; do
            run &
            PID=$!

            log info "Waiting for signal... (^C to quit)"
            read -r _ < "$FIFO_PATH"
            log info "Signal received, restarting..."

            restart
        done
    else
        log error "An instance of \"$0\" is already running. If this is not the case, remove the file $FIFO_PATH and restart."
    fi
}

# @cmd Signal that the project should be rebuilt and restarted
signal() {
    if [[ -p "$FIFO_PATH" ]]; then
        echo "" > "$FIFO_PATH"
    else
        log error "An instance of \"$0\" is not running with the subcommand \"wait-signal\"."
    fi
}

eval "$(argc --argc-eval "$0" "$@")"
