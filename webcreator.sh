#!/bin/bash



function usage
{
    echo "Usage: ./webcreator.sh <root_directory> <text_file> w p "
}


root_directory=
text_file=
w=
p=
lines=


# proccess arguments

#http://linuxcommand.org/wss0130.php

if [ "$1" != "" ];
then
    root_directory=$1
    shift
    if [ "$1" != "" ];
    then
        text_file=$1
        shift
        if [ "$1" != "" ];
        then
            w=$1
            #http://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
    				re='^[0-9]+$'
            if ! [[ $w =~ $re ]] ;
            then
              echo "w should be an integer"
              usage
              exit 1
            fi
            shift
            if [ "$1" != "" ];
            then
                p=$1
                if ! [[ $p =~ $re ]] ;
                then
                  echo "p should be an integer"
        					usage
        					exit 1
        				fi
                shift
            else
                usage
                exit 1
            fi
        else
            usage
            exit 1
        fi
    else
        usage
        exit 1
    fi
else
    usage
    exit 1
fi


# check if root directory exists

#https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
if [ ! -d "$root_directory" ]; then
  # Control will enter here if $root_directory doesn't exist.
  echo "root_directory does not exist"
  exit 1
fi


# check if text file exists

#https://stackoverflow.com/questions/40082346/how-to-check-if-a-file-exists-in-a-shell-script/40082454
if [ ! -e "$text_file" ]
then
    echo "text_file does not exist"
    exit 1
fi


# check number of lines

#https://stackoverflow.com/questions/12022319/bash-echo-number-of-lines-of-file-given-in-a-bash-variable-without-the-file-name
lines=0
lines=$(wc -l < "$text_file")
if [ "$lines" -lt "10000" ];
then
    echo "text_file has fewer than 10000 lines ("$lines")"
    exit 1
fi



# purge if directory not empty

#https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
if [ "$(ls -A "$root_directory")" ]; then
     	echo "Purging! $root_directory is not Empty"
	#https://stackoverflow.com/questions/8631990/how-can-i-delete-contents-in-a-folder-using-a-bash-script
	rm -rfv $root_directory/*
else
    	echo "$root_directory is Empty"
fi



# create directories -> pages -> content

#https://unix.stackexchange.com/questions/48750/creating-numerous-directories-using-mkdir/48752
n=0
max=0
let max=w-1
while [ "$n" -le "$max" ]; do
  	# check if mkdir successfull
  	mkdir "$root_directory/site$n"
	if [ ! -e "$root_directory/site$n" ]; then
	     	echo "Error! Directory not created"
		exit 1
	fi




	# create pages
	l=0
	max_2=0
	let max_2=p-1




filename=


while [ "$l" -le "$max_2" ]; do


	filename="$root_directory/site$n/page"$n"_$RANDOM.html"
	#echo "$filename"


	while [ -e "$filename" ]; do


		echo "$l"
	

		filename="$root_directory/site$n/page"$n"_$RANDOM.html"
		echo "$filename"

	done


	touch $filename
	# add data to the pages
	#https://www.linuxquestions.org/questions/programming-9/create-a-text-file-using-bash-301528/
	echo data >> $filename


	l=`expr "$l" + 1`


done
	




	# fill pages









  	n=`expr "$n" + 1`
done













