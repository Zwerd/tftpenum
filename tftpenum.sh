#!/bin/bash
# this script was written by zwerd
IFS=$'\n'
tftpsrv=$1
wordlist=$2
localdir=./$3

# How to run the script:
[ $# -eq 0 ] && { echo "Usage: $0 <tftp ip> <tftp wordlist> <local dir>"; exit 1; }


for file in $(cat $wordlist);
do 
	echo -e "\e[0mtrying rquest $file"
	error=$(tftp -m binary $tftpsrv -c get $file)

	#checking how much directory in path and calculate the subdir
	fullPathNumber=$(echo $file| awk -F/ '{print NF}')
	subdirNumber=$(expr -$fullPathNumber + 1)
	filename=$(echo $file | cut -d"/" -f$fullPathNumber)
	echo $error | cut -d" " -f1
	echo $file
	echo $filename

	if [[ 'Error' == $(echo $error | cut -d" " -f1) ]]
	then
		echo -e "\e[1m\e[91m[-] \e[0m file $filename not exist"
		echo "going to rm"
		rm ./$filename 2>/dev/null

	#if file was download then create the dirs and move the file to the currect path.
	elif [ -f $filename ] && [ "{$file: -1}" != "/" ]
	then
		#create the directories and subdirectories
		echo -e "\e[1m\e[92m[+] \e[0mcreating full path for $filename"
		fullPath=$(echo $file | cut -d"/" -f $subdirNumber)
		echo $fullPath
		echo "this is full path: $localdir$fullPath"
		mkdir -p $localdir$fullPath
		mv $filename $localdir$fullPath
	fi
done
