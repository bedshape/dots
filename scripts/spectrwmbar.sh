#!/bin/sh

# Function to get RAM usage
ram_usage() {
    free -h | grep ^Mem | tr -s ' ' | cut -d ' ' -f 3,2 | tr ' ' '/'
}

# Function to get PipeWire volume
pw_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2 | tr -d '%' | awk '{print int($1 * 100)"%"}'
}

# Function to get current date and time
datetime() {
    date "+%d/%m/%Y | %T"
}

# Bar loop
while true; do
    echo "   $(ram_usage) | 󰕾  $(pw_volume) | $(datetime) |  "
    sleep 1
done

