#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Params: number of apps to install"
	exit
fi    
 
x=1
for i in $( find . -name "*.apk" ); 
    do
       adb install -dg $i
       if [ "$((x++))" -ge "$1" ]; then 
          break;
       fi  
    done

echo "You have installed $1 apps"
