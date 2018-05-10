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


#https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
if [ ! -d "$root_directory" ]; then
  # Control will enter here if $root_directory doesn't exist.
  echo "root_directory does not exist"
  exit 1
fi


#https://stackoverflow.com/questions/40082346/how-to-check-if-a-file-exists-in-a-shell-script/40082454
if [ ! -e "$text_file" ]
then
    echo "text_file does not exist"
    exit 1
fi


#https://stackoverflow.com/questions/12022319/bash-echo-number-of-lines-of-file-given-in-a-bash-variable-without-the-file-name
lines=$(wc -l < "$text_file")
if [ "$lines" < "10000" ];
then
    echo "text_file has fewer than 10000 lines ($lines)"
    exit 1
fi
