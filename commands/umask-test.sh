#!/bin/bash
function random_octa_permission(){ echo $(( ( RANDOM % 8 ) ));};

limit_questions=$1

if [ "$limit_questions" = "" ]; then
	limit_questions=9999;
fi

echo $limit_questions;

total=0
correct=0
wrong=0

baseFolderForTesting="testArea/";

mkdir -p $baseFolderForTesting;

while true
do
	user_permission=$(random_octa_permission)
	group_permission=$(random_octa_permission)
	others_permission=$(random_octa_permission)
	currentParam=$user_permission$group_permission$others_permission	
	clear;
	echo "what is the resulting permission for a new file when using ";
	echo -e "\033[32mumask $user_permission$group_permission$others_permission\033[0m?";
	echo "P.S. It should be in the format: ---------";
	echo;
	echo "To end the simulation, use \"exit\".";
	echo;
        rm "$baseFolderForTesting""$currentParam"-file 2> /dev/null;
        umask $currentParam;
        touch "$baseFolderForTesting""$currentParam"-file;
        rmdir "$baseFolderForTesting""$currentParam"-folder 2>/dev/null;
        mkdir "$baseFolderForTesting""$currentParam"-folder;

	folderAnswer=$(ls -l $baseFolderForTesting | grep "${currentParam}-folder" | awk 'BEGIN{FS=" "}{print $1}' | grep -Po '[rwx-]{9}(?=\.|\+)');
	fileAnswer=$(ls -l $baseFolderForTesting | grep "${currentParam}-file" | awk 'BEGIN{FS=" "}{print $1}' | grep -Po '[rwx-]{9}(?=\.|\+)');
	
	read -e -n 9 file_answer;
	echo;
	if [ "$file_answer" = "exit" ] || [ $total -eq $limit_questions ]; then
		echo "Your results:";
		echo -e "	Correct: \033[32m$correct\033[0m";
		echo -e "	Wrong: \033[31m$wrong\033[0m";
		echo "  Total: $total"
		break;
	fi

	total=$(expr $total + 2);

	if [ "$file_answer" = "$fileAnswer" ]; then
		echo -e "\033[32mcorrect\033[0m!";
		correct=$(expr $correct + 1);
	else
		echo -e "\033[31mwrong! the right answer for file is $fileAnswer\033[0m";
		wrong=$(expr $wrong + 1);
	fi

        echo "what is the resulting permission for a new folder when using ";
        echo -e "\033[32mumask $user_permission$group_permission$others_permission\033[0m?";
	
        read -e -n 9 folder_answer;
	echo;
        if [ "$folder_answer" = "exit" ] || [ $total -eq $limit_questions ]; then
		wrong=$(expr $wrong + 1);
                echo "Your results:";
                echo "  Correct: $correct";
                echo "  Wrong: $wrong";
                echo "  Total: $total"
                break;
        fi

        if [ "$folder_answer" = "$folderAnswer" ]; then
                echo -e "\033[32mcorrect!\033[0m";
                correct=$(expr $correct + 1);
        else
		echo -e "\033[31mwrong!\033[0m the right answer for folder is $folderAnswer";
                wrong=$(expr $wrong + 1);
        fi

	echo;
	echo -e "\033[32mPress enter to next line.\033[0m";
	read;

done
