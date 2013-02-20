#!/bin/bash

# Lego Motor Raspi Driver
# TBD
# installation
# GIT
# wiring all to the pi including the driver
#
# switch486 @ 2013
# http://hardwareblacksmith.blogspot.com/
# Licensed under the CC BY-SA licence (see the wiringPi library for its licence).

# ---------------------------- Variable definitions

####
# Pinout diagram and description
# (using the wiringPi Pins: https://projects.drogon.net/raspberry-pi/wiringpi/pins/)
####

# lamps indicating the system status
 left=0
right=1

# ---------------------------- Code

#######
#
#######
setup () {
  echo "-Setup"
  echo "--Setup the motor driver"
  for i in $left $right ; do gpio mode  $i out ; done
  for i in $left $right ; do gpio write $i   0 ; done

  echo "-Setup finished"
}

#######
#
#######
driveRight ()
{
  echo "-> drive Right"
  gpio write $right 1
  sleep 7
  gpio write $right 0
  echo "-=-=-=- sleep"
}

#######
#
#######
driveLeft () {
  echo "<- drive Left"
  gpio write $left 1
  sleep 5
  gpio write $left 0
  echo "-=-=-=- sleep"
}


#######
#
#######
setup
while true; do
 driveLeft
 sleep 2
 driveRight
 sleep 2
done
