#!/bin/bash

#Lab 4 script by Keshav Dial

#prints Menu
printf '%0.s-' {1..38}
printf "\nPROGRAM MENU \n1 - Add sequence to file\n2 - View file contents on the screen\n0 - Exit program\n"
printf '%0.s-' {1..38}
printf "\n"

#reads User Input
read entry

#if left blank reload program
if [ -z $entry ]; then 
	exec bash "$0"
	
#check for 0 then quit
elif [ $entry == 0 ]; then
	echo "-Goodbye-"
	exit 1
	
#check for 1	
elif [ $entry == 1 ]; then
	echo "Enter an existing file name you wish to append to"
	read filename
	
	#if nothing is entered, quit
	if [ -z $filename ]; then 
			echo "-Goodbye-"
			exit
	fi
	
	#while file does not exist, loop
	while [ ! -e $filename ] 
	do
		echo "ERROR: File Does Not Exist"
		echo "Enter Valid Name or 0 to Exit or Leave Blank to Exit"
		read filename
		
		#if 0 is entered, quit
		if [ "$filename" == '0' ]; then 
			echo "-Goodbye-"
			break
		fi
		
		#if nothing entered, quit
		if [ -z $filename ]; then 
			echo "-Goodbye-"
			exit
		fi		
	done
	
	#if file exists, APPEND
	if [ -e $filename ]; then 
		echo "Enter what sequence to be added to the file"
		read append
		echo $append >> $filename
		exit
	fi
	
#check for 2	
elif [ $entry == 2 ]; then
	echo "Enter an existing file name you wish to read"
	read filename
	
	#if nothing is entered, quit
	if [ -z $filename ]; then 
			echo "-Goodbye-"
			exit
	fi
	
	#while file does not exist, loop
	while [ ! -e $filename ]
	do
		echo "ERROR: File Does Not Exist"
		echo "Enter Valid Name or 0 to Exit or Leave Blank to Exit"
		read filename
		
	#if 0 is entered, quit
		if [ "$filename" == '0' ]; then 
			echo "-Goodbye-"
			break
		fi
		
	#if nothing entered, quit
		if [ -z $filename ]; then 
			echo "-Goodbye-"
			exit
		fi		
	done
	
	#if file exists, READ
	if [ -e $filename ]; then 
		cat $filename
		echo "-Goodbye-"
		exit
	fi
	
#if entry is not 0,1,2 then reload script
else
	printf "\n"
	exec bash "$0"
fi
