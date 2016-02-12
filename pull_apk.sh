# !/bin/bash
mkdir output;
cd output;
x=0
for i in $(adb shell pm list packages -f -3 | cut -d= -f 1 | cut -d ":" -f 2); 
	do 
		((x++));
		mkdir $x;
		cd $x;
		adb pull $i;
		cd ..	  
	done
