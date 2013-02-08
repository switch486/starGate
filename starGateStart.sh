#!/bin/bash

# Star Gate Lego Raspi Driver
# TBD
# installation
# GIT
# wiring all to the pi including the driver
#
# switch486 @ 2013
# http://hardwareblacksmith.blogspot.com/
# Licensed under the CC BY-SA licence (see the wiringPi library for its licence).

## TODO - fails during the running of the script
## TODO - no output from mpg123 should be visible!

# ---------------------------- Variable definitions

musicPath="/home/pi/starGate/music.mp3"

####
# Pinout diagram and description
# (using the wiringPi Pins: https://projects.drogon.net/raspberry-pi/wiringpi/pins/)
####

startButton=0

# lamps indicating the system status
systemRunning=1
   systemIdle=2

# motor wiring done like in: http://hardwareblacksmith.blogspot.com/2012/01/complexity-minimization.html
# image 1 when not using the U part of the stepper motor driver
  motorVPlus=3
motorVGround=4
  motorWPlus=5
motorWGround=6

# stargate 7 lamps for the 'seals' TBD
lamp0=7
lamp1=8
lamp2=9
lamp3=10
lamp4=11
lamp5=12
lamp6=13

# photo detectors indicating if the concrete step has been already done
detectorL=14
detectorR=15

# the 16 pin is used for the LED strips starting
ledStart=16

# NOTE - turing and lightning sequences
# # # # #
#############################

#TODO - will this actually work?
 turningSequence=(5 -3 2 -7 4 2 5)
lightingSequence=($lamp3 $lamp0 $lamp6 $lamp1 $lamp4 $lamp2 $lamp5)

#############################
# # # # #

# ---------------------------- Code

#######
#
# Setup all diodes, buttons, detectors and motor
#
#######
setup () {
  echo "-Setup"
  echo "--Setup the status lamps"
  for i in $systemRunning $systemIdle ; do gpio mode  $i out ; done
  for i in $systemRunning $systemIdle ; do gpio write $i   0 ; done

  echo "--Setup the seal lamps"
  for i in $lamp0 $lamp1 $lamp2 $lamp3 $lamp4 $lamp5 $lamp6 ; do gpio mode  $i out ; done
  for i in $lamp0 $lamp1 $lamp2 $lamp3 $lamp4 $lamp5 $lamp6 ; do gpio write $i   0 ; done

  echo "--Setup the button"
  gpio mode  $startButton in

  echo "--Setup the motor driver"
  for i in $motorVPlus $motorVGround $motorWPlus $motorWGround ; do gpio mode  $i out ; done
  for i in $motorVPlus $motorVGround $motorWPlus $motorWGround ; do gpio write $i   0 ; done

  echo "--Setup the detectors"
  for i in $detectorL $detectorR ; do gpio mode  $i in ; done

  echo "--Setup the Led Stripe"
  gpio mode $ledStart out

  echo "-Setup finished"
}

#######
#
# System diagnosis
# go through all diodes and light them up and down
# move motor one step left and one step right
#
#######
diagnosis () {
  echo "-Diagnosis start"


  echo "-Diagnosis end"
}

#######
#
# Wait for the system to be started
#
#######
waitForStart ()
{
  echo "-Waiting for the start button"
  while [ `gpio read $startButton` = 1 ]; do
    sleep 0.1
  done
  echo "--Button pressed"
}

#######
#
# Methods indicating if the system is working or waiting for work
#
#######
setSystemWorking ()
{
  echo "-System work started"
  gpio write $systemRunning 1
  gpio write $systemIdle 0
}
setSystemWaiting ()
{
  echo "-System work ended - waiting"
  gpio write $systemRunning 0
  gpio write $systemIdle 1
}


#######
#
# controlling the music
#
#######
playMusic () {
#TODO - will this work?
  echo "-Music starting"
  mpg123 $musicPath & >> /dev/null
  PID=$!
  echo $PID > music.pid
}
stopMusic () {
  echo "-Music stopping"
  PID=`cat music.pid`
  kill $PID
#TODO - repair!!!!!!
  sleep 30
}

#######
#
# Reset the seals
#
#######
reset () {
  for i in $lamp0 $lamp1 $lamp2 $lamp3 $lamp4 $lamp5 $lamp6 ; do gpio write $i   0 ; done
}

#######
#
# System diagnosis
# go through all diodes and light them up and down
# move motor one step left and one step right
#
#######
diagnosis () {
  echo "-Diagnosis start"
  for i in $lamp0 $lamp1 $lamp2 $lamp3 $lamp4 $lamp5 $lamp6 ; do
    gpio write $i   1 ; 
    sleep 1
  done
  reset

  echo "-Diagnosis end"
}

#######
#
# Fire The LED Stripes
#
#######
fireLedStripes () {
  gpio write $ledStart 1;
  sleep 15;
  gpio write $ledStart 0;
}

#######
#
# Start the sequence setting on the motor
#
#######
startSequencing () {
#TODO - implement!
  sleep 30

}


#######
#
# The Main Program - start everything
#
#######
setup
diagnosis
while true; do
  waitForStart
  setSystemWorking
  playMusic
  startSequencing
  fireLedStripes
  reset
  stopMusic
  setSystemWaiting
done
