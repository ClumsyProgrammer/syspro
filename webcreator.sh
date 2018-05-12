#!/bin/bash

# variables
root_directory=
text_file=
w=
p=
lines=
k=
m=
f=
q=
current_site=
current_page=



# functions

function usage
{
    echo "Usage: ./webcreator.sh <root_directory> <text_file> w p "
}


function random_k
{

# http://tldp.org/LDP/abs/html/randomvar.html

k=0
rand_num=0
range=0

range=`expr "$lines" - 2000`
rand_num=$RANDOM
#echo "random number =  $rand_num"
#echo "lines = $lines"
#echo "range = $range"
let k="rand_num %= $range"

echo "k = $k"

}


function random_m
{

m=0
rand_num_2=0

rand_num_2=$RANDOM
#echo "random number =  $rand_num"
let m="rand_num %= 1000"
#echo "$m"
let m="m + 1000"

echo "m = $m"

}


function find_to_array_all_pages
{

# https://superuser.com/questions/273187/how-to-place-the-output-of-find-in-to-an-array
# https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash


array=()
while IFS=  read -r -d $'\0'; do
    array+=("$REPLY")
done < <(find ./sites -name "*.html" -print0)


for i in ${array[@]}
do

    echo $i

    current_page=${i:14}
    current_site=${i:14:5}

    echo "current site:  $current_site "
    echo "current page:  $current_page "

done

}


function find_to_array_external_links
{

# https://superuser.com/questions/273187/how-to-place-the-output-of-find-in-to-an-array
# https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash


array=()
while IFS=  read -r -d $'\0'; do
    array+=("$REPLY")
done < <(find ./sites -name "*.html" ! -name "*$current_site*" -print0)


for i in ${array[@]}
do
    echo $i
done

}


function find_to_array_internal_links
{

# https://superuser.com/questions/273187/how-to-place-the-output-of-find-in-to-an-array
# https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash


array=()
while IFS=  read -r -d $'\0'; do
    array+=("$REPLY")
done < <(find ./sites -name "*$current_site*.html" ! -name "*$current_page*" -print0)


for i in ${array[@]}
do
    echo $i
done

}


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
  echo "$root_directory does not exist"
  exit 1
fi


# check if text file exists

#https://stackoverflow.com/questions/40082346/how-to-check-if-a-file-exists-in-a-shell-script/40082454
if [ ! -e "$text_file" ]
then
    echo "$text_file does not exist"
    exit 1
fi


# check number of lines

#https://stackoverflow.com/questions/12022319/bash-echo-number-of-lines-of-file-given-in-a-bash-variable-without-the-file-name
lines=0
lines=$(wc -l < "$text_file")
if [ "$lines" -lt "10000" ];
then
    echo "$text_file has fewer than 10000 lines ("$lines")"
    exit 1
fi



# purge if directory not empty

#https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
if [ "$(ls -A "$root_directory")" ]; then
     	echo "Purging! $root_directory is not Empty"
	#https://stackoverflow.com/questions/8631990/how-can-i-delete-contents-in-a-folder-using-a-bash-script
	#rm -rfv $root_directory/*  #verbose
	rm -rf $root_directory/*
else
    	echo "$root_directory is Empty"
fi



# create sites & pages

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




	# create pages in this site
	l=0
	max_2=0
	let max_2=p-1
	filename=


	while [ "$l" -le "$max_2" ]; do


		filename="$root_directory/site$n/page"$n"_$RANDOM.html"


		# check if the same filename exists
		while [ -e "$filename" ]; do

			filename="$root_directory/site$n/page"$n"_$RANDOM.html"
			echo "$filename"

		done

		# create empty page
		touch $filename
		# check if successful
		if [ -e "$filename" ];
		then
		echo "$filename created"
		else
		echo "error while creating $filename"
		exit 1
		fi
	
		# next page
		l=`expr "$l" + 1`


	done
	
	# next site
  	n=`expr "$n" + 1`

done






# place content in every page




# for each page



# random k
random_k
# random m
random_m






current_site="page1"
current_page="page1_1234"

# find to array

echo "all pages"

find_to_array_all_pages

echo "internal links"

find_to_array_internal_links

echo "external links"

find_to_array_external_links








