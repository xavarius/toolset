#!/bin/bash

usage() { echo "./install_apk.sh [-f|-a|-n <amount>|-s <serialNumber> |-d <directory>]"; }

MAX_AMOUNT_OF_APPS=10000
AMOUNT_APPS_TO_INSTALL=0

# args: apps amount | directory | serial number
install() {
	

	echo "amout $1  dir $2 serial $3"
	exit 0;
	echo "Installing..."
	x=$1 # amount

	for i in $( find $2 -name "*.apk" ); do
       		`adb install -dg -s $3 $i`
       		if [ "$((x++))" -ge "$1" ]; then 
          		break;
       		fi  
    	done

echo "You have installed $1 apps"
}

install_On_All_Devices() {
	echo "install on all"
	install $1 $2 $3
	exit 0
}

while getopts ":fas:d:n:" opt; do
	case $opt in
	  a)
		a="notempty"
		;;
	  s)
		s={OPTARG}
		;;
	  d)
		d={OPTARG}
		;;
	  n)
		n={OPTARG}
		;;
	  f)
		f=$MAX_AMOUNT_OF_APPS
		;;
	  \?)
		usage
		;;
	  :)
		usage
		;;
	esac
done

#check if user gave proper params

correct_flag=1

if [ ! -z "${a}" ] && [ ! -z "${s}" ]; then
	echo "Install to ALL (-a) or on device with serial number (-s <serialNbr>)" 
	correct_flag=0
fi

if [ -z "${d}" ] || [ ! -d "${d}" ]; then
	echo "Given dir is not a dir/exist or you have not provided -d <dir>"
	correct_flag=0
fi 

if [ ! -z "${n}" ] && [ ! -z "${f}" ]; then
	echo "Provide number (-n <amount>) > 0 of apps to install or install all -f" 
	correct_flag=0
fi

if [ ! -z "${n}" ] && [[ $n -le 0 ]]; then
	echo "Install more than 0 apps"
	correct_flag=0
else 
	AMOUNT_APPS_TO_INSTALL=$n
fi

if [ ! -z "${f}" ]; then 
	AMOUNT_APPS_TO_INSTALL=$MAX_AMOUNT_OF_APPS 
fi

if [[ $correct_flag -e 0 ]]; then
	exit 1
fi

# main part

if [ ! -z "${a}" ]; then
	install_On_All_Devices $AMOUNT_APP_TO_INSTALL ${d} ${s}
elif [ ! -z "${s}" ]; then
	install $AMOUNT_APP_TO_INSTALL ${d} ${s}
fi
