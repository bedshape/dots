#!/bin/bash

echo "1) launch dwl"
echo "2) stay in tty"
read -p ">> " choice

case $choice in
    1)
        slstatus 
	start.sh
        ;;
    2)
	;;
    *)
        echo "invalid choice, staying in tty."
        ;;
esac

