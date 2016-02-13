#!/bin/bash

usage() { echo "./install_apk.sh [-f|-a|-n <amount>|-s <serialNumber> |-d <directory>]"; exit 1; }

ERROR_FLAG=0
MAX_AMOUNT_OF_APP=10000
AMOUNT_APPS_TO_INSTALL=0

# args: apps amount | directory | serial number
install() {
	
	echo "amout $1  dir $2 serial $3"
	exit 0;
	echo "Installing... on device $3"
	
	x=0
	for i in $( find $2 -name "*.apk" ); do
       		`adb install -dg -s $3 $i`
       		if [ "$((x++))" -ge "$1" ]; then 
          		break;
       		fi  
    	done

	`clear`
	echo "Installed $1 apps on device $3";
}

install_On_All_Devices() {
	echo "all devices"
	install $1 $2 $3
	exit 0
}

while getopts ":fas:d:n:" opt; do
	case $opt in
	  a)
		a="notempty"
		;;
	  s)
		s=${OPTARG}
		;;
	  d)
		d=${OPTARG}
		;;
	  n)
		n=${OPTARG}
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

#parse input options and args : validate

if [ ! -z "${a}" ] && [ ! -z "${s}" ]; then
	echo "Install to ALL (-a) or on device with serial number (-s <serialNbr>)" 
	ERROR_FLAG=1
fi

if [[ -z "${d}" ]] || [[ ! -d "${d}" ]]; then
	echo "Given dir is not a dir/exist or you have not provided -d <dir>"
	ERROR_FLAG=1
fi 

if [ ! -z "${n}" ] && [ ! -z "${f}" ]; then
	echo "Provide number (-n <amount>) > 0 of apps to install or install all -f" 
	ERROR_FLAG=1
fi

if [ ! -z "${n}" ] && [[ ${n} -le 0 ]]; then
	echo "Install more than 0 apps"
	ERROR_FLAG=1
elif [ ! -z "${n}" ]; then 
	AMOUNT_APPS_TO_INSTALL=$n
fi

if [ ! -z "${f}" ]; then 
	AMOUNT_APPS_TO_INSTALL=$MAX_AMOUNT_OF_APPS 
fi

if [[ $ERROR_FLAG -eq 1 ]]; then
	exit 1
fi

# main part

if [ ! -z "${s}" ]; then
	install $AMOUNT_APPS_TO_INSTALL ${d} ${s}
else
	install_On_All_Devices $AMOUNT_APPS_TO_INSTALL ${d}
fi

echo "Work is done";
