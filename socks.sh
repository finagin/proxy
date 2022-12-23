#!/usr/bin/env bash

trap ctrl_c INT

function ctrl_c() {
    exit 0;
}

function init() {
    SOCKS_PORT=${1:-1080};
    SOCKS_HOST=${2:-127.0.0.1};
}

ARGS=()

if [ "$1" == "help" ]; then

    echo "Usage:
    socks help          - Usage help
    socks status        - Show status of socks proxy
    socks [PORT] [HOST] - Run socks proxy
    "

    exit 0;

elif [ "$1" == "status" ]; then

    echo "Running socks list:";

    screen -ls | grep -o "SOCKS5-[^:]*:[0-9]*"

    exit 0;

elif [ "$1" == "demon" ]; then
    shift 1

    init $1 $2

    ssh -N -gv -D $SOCKS_PORT $SOCKS_HOST

    sleep 5

else

    init $1 $2

    SCREEN_NAME="SOCKS5-$SOCKS_HOST:$SOCKS_PORT"

    ARGS+=(screen -S $SCREEN_NAME -d -m)

fi;

ARGS+=(bash $0 demon $@)

"${ARGS[@]}"
