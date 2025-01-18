#!/bin/bash

IDLE=$(pidof swayidle)

if [ -z "$IDLE" ]; then
	echo "no such process"
	exit 1
fi

kill $IDLE
echo "idle (PID $IDLE) killed"
