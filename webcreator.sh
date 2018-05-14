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
array_all=()
links_array=()
pages_without_link=()
$index_1=
$index_2=





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
let m="rand_num_2 %= 1000"
#echo "$m"
let m="m + 1000"

echo "m = $m"

}



function links_subset
{

# https://superuser.com/questions/273187/how-to-place-the-output-of-find-in-to-an-array
# https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash


#echo "original external links"

array_ext=()
while IFS=  read -r -d $'\0'; do
    array_ext+=("$REPLY")
done < <(find ./sites -name "*.html" ! -name "*$current_site*" -print0)


#for i in ${array_ext[@]}
#do
#    echo $i
#done

# https://techfertilizer.wordpress.com/2012/06/15/sorting-arrays-in-bash-shell-scripting/

#echo "random subset"
array_ext_2=($(for each in ${array_ext[@]}; do echo $each; done | sort -R | tail -$q ))


#for i in ${array_ext_2[@]}
#do
#    echo $i
#done



# https://superuser.com/questions/273187/how-to-place-the-output-of-find-in-to-an-array
# https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash


#echo "original internal links"

array_int=()
while IFS=  read -r -d $'\0'; do
    array_int+=("$REPLY")
done < <(find ./sites -name "*$current_site*.html" ! -name "*$current_page*" -print0)


#for i in ${array_int[@]}
#do
#    echo $i
#done


# https://techfertilizer.wordpress.com/2012/06/15/sorting-arrays-in-bash-shell-scripting/

#echo "random subset"
array_int_2=($(for each in ${array_int[@]}; do echo $each; done | sort -R | tail -$f ))


#for i in ${array_int_2[@]}
#do
#    echo $i
#done

# https://stackoverflow.com/questions/31143874/how-to-concatenate-arrays-in-bash
echo "final list of links for this page"

links_array_draft=( "${array_int_2[@]}" "${array_ext_2[@]}" )
links_array=($(for each in ${links_array_draft[@]}; do echo $each; done | sort -R ))


for i in ${links_array[@]}
do
    echo $i
done



#echo "---------------------------------------------"
#echo "pages_without_link"
#for i in ${pages_without_link[@]}
#do
#    echo $i
#done
#echo "---------------------------------------------"


# https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash
pages_without_link_new=()
for i in "${pages_without_link[@]}"; do
     skip=
     for j in "${links_array[@]}"; do
         [[ $i == $j ]] && { skip=1; break; }
     done
     [[ -n $skip ]] || pages_without_link_new+=("$i")
 done


#echo "pages without link new"
#for i in ${pages_without_link_new[@]}
#do
#    echo $i
#done
#echo "---------------------------------------------"


unset pages_without_link

pages_without_link=("${pages_without_link_new[@]}")




echo "pages without link"
for i in ${pages_without_link[@]}
do
    echo $i
done
echo "---------------------------------------------"


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

# f and q parameters


f=`expr "$p" / 2`
f=`expr "$f" + 1`

q=`expr "$w" / 2`
q=`expr "$q" + 1`



echo "f = $f"
echo "q = $q"





# https://superuser.com/questions/273187/how-to-place-the-output-of-find-in-to-an-array
# https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash



while IFS=  read -r -d $'\0'; do
    array_all+=("$REPLY")
done < <(find ./sites -name "*.html" -print0)

#https://stackoverflow.com/questions/19417015/how-to-copy-an-array-in-bash
pages_without_link=("${array_all[@]}")




# for each page

for z in ${array_all[@]}
do

	#echo $z


	# https://www.tldp.org/LDP/abs/html/string-manipulation.html

	# SOS! NO p or _ in the $root_directory
	#echo `expr index "$z" p`
	#echo `expr index "$z" _`

	ind_1=`expr index "$z" p`
	ind_2=`expr index "$z" _`

	let ind_2=ind_2-ind_1
	let ind_1=ind_1-1

	current_page=${z:$ind_1}
	current_site=${z:$ind_1:$ind_2}

	echo "current site:  $current_site "
	echo "current page:  $current_page "


	# random k
	random_k
	# random m
	random_m

	sum=`expr "$f" + "$q"`
	grammes=`expr "$m" / "$sum"`
	echo "grammes = $grammes"

	echo "internal & external links subset"

	links_subset


	# add header
	# https://stackoverflow.com/questions/15583168/bash-script-file-creation-and-fill

	# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n
	printf "<!DOCTYPE html>\n<html>\n\t<body>\n" >> "$z"



	# Fill content
	# --------------------------------------------------------------------------------









	let index_1=k
	let index_2=k+grammes

	for l in ${links_array[@]}
	do

	# https://stackoverflow.com/questions/6207573/how-to-append-output-to-the-end-of-text-file-in-shell-script-bash
	# https://unix.stackexchange.com/questions/61726/easy-way-to-copy-lines-from-one-file-to-another
	# https://stackoverflow.com/questions/9259658/copy-paste-part-of-a-file-into-another-file-using-terminal-or-shell
	sed  -n -e  ""$index_1","$index_2"p" "$text_file" >> "$z"


	#sed -e -n `"$index_1","$index_2" p` < "$text_file" > "$z"


	

	echo "<a href=""file:///home/katerina/Desktop/syspro/"$l">"$l"</a>" >> "$z"


	let index_1=index_2+1
	let index_2=index_2+1+grammes


	done








	#---------------------------------------------------------------------------------

	# add header tail

	printf "\t</body>\n</html>\n" >> "$z"


done




