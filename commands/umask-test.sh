#!/bin/bash
firstParam=$1
if [ "$firstParam" = "" ]; then
	firstParam="022";
fi
IFS=',';
for currentParam in `echo "$firstParam"`;
do
	echo "umask $currentParam";
	rm "$currentParam"-file 2> /dev/null;
	umask $currentParam;
	touch "$currentParam"-file;
	rmdir "$currentParam"-folder 2>/dev/null;
	mkdir "$currentParam"-folder;
	echo "FOLDER RESULTING PERMISSIONS: ";
	ls -l | grep "$currentParam"-folder | awk 'BEGIN{FS=" "}{print $1}';
	echo;
	echo;

        echo "FILE RESULTING PERMISSIONS: ";
        ls -l | grep "$currentParam"-file | awk 'BEGIN{FS=" "}{print $1}';
        echo;
        echo;

done
