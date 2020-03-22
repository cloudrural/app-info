#!/bin/bash

function _usage() {
    propFile="$APP_HOME/webapps/appProps.list"

    echo "    Usage:"
    echo "        docker run --network <network_name> --name <container_name> --hostname <hostname>"
    echo "          -p <host_port>:<container_port> -e <env_name>=<value> -e <env_name>=<value>..."


    while read -r line
    do
	[ "$line" = "" ] || [ "${line:0:1}" = "#" ] && continue
	f1=$(echo $line | cut -d, -f1)
	f3=$(echo $line | cut -d, -f3)
	f4=$(echo $line | cut -d, -f4)
	f5=$(echo $line | cut -d, -f5)

	if [ "$f4" = "" ]
	then
	    f4=blank
	fi

	if [ "$f1" = "1" ]
	then
	    printf '           %s\t %s Default: %s\n' "$f3" "$f5" "$f4" | expand -t 50
	fi
    done < "$propFile"
}

function _shutdown() {
    cd $APP_HOME/bin
	./catalina.sh stop
}

########### SIGINT handler ############
function _int() {
    echo "Stopping App."
    echo "SIGINT received, shutting down the server!"
    _shutdown
}

########### SIGTERM handler ############
function _term() {
    echo "Stopping App."
    echo "SIGTERM received, shutting down the server!"
    _shutdown
}

########### SIGKILL handler ############
function _kill() {
    echo "Stopping app."
    echo "SIGKILL received, shutting down the server!"
    _shutdown
    kill -9 $childPID
}

# Set SIGINT handler
trap _int SIGINT

# Set SIGTERM handler
trap _term SIGTERM

# Set SIGKILL handler
trap _kill SIGKILL

if [ "$help" != "" ]; then
    _usage
    exit 0;
fi;

if [ ! -f .configured ]; then
    touch .configured

    cd $APP_HOME/webapps
    ./configureProps.sh APP appProps.list appProps/

fi;

cd $APP_HOME/bin
./catalina.sh run

touch ../logs/appserver.log
tail -f ../logs/appserver.log &

childPID=$!
wait $childPID
