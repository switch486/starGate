#!/bin/bash

# sterownik makiety lego
# switch486 2013

# przyciski z lampka (wejscie)

button1=12
button2=2
button3=16

# lampki przyciskow (wyjscie)

lamp1=13
lamp2=14
lamp3=15

# moduly sterujace (wyjscie)

mod1=8
mod2=9
mod3=1
mod4=6
mod5=5
mod6=4

##
wybranyPrzycisk="x"

#######
#
#######
setup () {
  echo "-Setup"
  echo "--Setup the motor driver"
  for i in $lamp1 $lamp2 $lamp3 $mod1 $mod2 $mod3 $mod4 $mod5 $mod6 ; do gpio mode  $i out ; done
  for i in $lamp1 $lamp2 $lamp3 $mod1 $mod2 $mod3 $mod4 $mod5 $mod6 ; do gpio write $i   0 ; done 
  for i in $button1 $button2 $button3 ; do gpio mode $i in ; done
  echo "-Setup finished"
}

######
#
######
wlaczPrzyciski () {
   for i in $lamp1 $lamp2 $lamp3 ; do gpio write $i 1 ; done
}

###### 
#
######
wylaczPrzyciski () {
   for i in $lamp1 $lamp2 $lamp3 ; do gpio write $i 0 ; done
}

######
# uwaga - przycisk musi miec podpiete zarowno 3,3V jak i 0V!!! 
# w przeciwnym wypadku rasPI bedzie mylnie interpretowac stan braku napiecia jako 0V
######
sprawdzPrzyciski () {
 while [ $wybranyPrzycisk = "x" ]; do
   if [ `gpio read $button1` = 1 ]
     then
      wybranyPrzycisk="1"
   elif [ `gpio read $button2` = 1 ]
     then
      wybranyPrzycisk="2"
   elif [ `gpio read $button3` = 1 ]
     then
      wybranyPrzycisk="3"
#   else

   fi
   sleep 0.1
 done
}

######
#
######
wykonajAkcje () {
 if [ $wybranyPrzycisk = "1" ]
  then
   akcjaButton1
 elif [ $wybranyPrzycisk = "2" ]
  then
   akcjaButton2
 elif [ $wybranyPrzycisk = "3" ]
  then
   akcjaButton3
 #else

 fi
}

######
#
######
akcjaButton1 () {
  echo "--Akcja1"
 gpio write $mod1 1
 i="0"
 while [ $i -lt 30 ]; do
 gpio write $mod2 1
 sleep 0.2
 gpio write $mod2 0
 sleep 0.1
 gpio write $mod2 1
 sleep 0.2
 gpio write $mod2 0
 sleep 0.3
 gpio write $mod2 1
 sleep 0.1
 gpio write $mod2 0
 sleep 0.1

 i=$[$i+1];
 done
 gpio write $mod1 0
}

######
#
######
akcjaButton2 () {  
  echo "--Akcja2"
 gpio write $mod3 1
 gpio write $mod4 1
 sleep 30 
 gpio write $mod3 0
 gpio write $mod4 0
}
 

######
#
######
akcjaButton3 () {  
  echo "--Akcja3"
 gpio write $mod5 1
 sleep 30
 gpio write $mod5 0
}
 


#######
# Program glowny
#######
setup
while true; do
 wlaczPrzyciski
 sprawdzPrzyciski
 wylaczPrzyciski
 wykonajAkcje
 wybranyPrzycisk="x"
 sleep 2
done

