#!/bin/bash

# STATICS

date=$(date +'%Y-%m-%d_%H-%M')

# CONFIGS

link=
path=
determine='='
log_path="$HOME/.download.$date.logfile.log"
links_to_download_path="$HOME/.download.links"

# FUNCTIONS

function_writeLog() {
  echo -e "\n\n####### --- $1 --- #######\n\n" >> $log_path
}

function_split() {
  if [ $2 == "link" ]
  then
    echo $1 | awk 'BEGIN { FS="="} {print $1}'
  elif [ $2 == "path" ]
  then
    echo $1 | awk 'BEGIN { FS="="} {print $2}'
  fi
}

function_checkPath() {
  if [ -d $1 ]
  then
    function_writeLog "DIRECTORY $1 WAS EXISTS"
  else
    function_writeLog "CREATE DIRECTORY $1"
    mkdir -p $1
  fi
}

function_writeLog LOG "FILE CREATED $date" 


if [ -f $links_to_download_path ]
then
  if [ -s $links_to_download_path ]
  then
    for line in `cat $links_to_download_path`
    do
      link="$(function_split $line "link")"
      path="$(function_split $line "path")"
      # TODO[ ]: CHECK LINK STATUS CODE
      function_checkPath $path
      wget -c $link -a $log_path -P $path --show-progress
    done
  else 
    echo "Your $links_to_download_path is empty to download."
  fi 
else
  touch $links_to_download_path
  echo -e "\nPlease fill the file ($links_to_download_path) like this format to download\n"
  echo -e "link=path\n"
  echo -e "THANKS ;)\n"
fi

