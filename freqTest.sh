#!/bin/bash
gpio mode 1 out

while :
do
        echo "loop1"
	gpio write 1 0; 
	sleep 0.2
        gpio write 1 1;
done

