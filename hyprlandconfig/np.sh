#!/bin/bash

status=$(playerctl -p musikcube status)
title=$(playerctl -p musikcube metadata title)
artist=$(playerctl -p musikcube metadata artist)

if [ "$status" = "Playing" ]; then
    if [ -z "$title" ] || [ -z "$artist" ]; then
        echo "no song playing"
    else
        echo "$artist - $title"
    fi
elif [ "$status" = "Paused" ]; then
    if [ -z "$title" ] || [ -z "$artist" ]; then
        echo "music paused"
    else
	    echo "paused $artist - $title"
    fi
else
	echo "nothing playing"
fi

