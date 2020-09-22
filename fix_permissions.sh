#!/bin/bash

dir=$(pwd)
group_id=100
usage="$(basename "$0") [-h] [-g] [-d] -- program to fix issues with permission when using docker.

where:
    -h : shows this help text.
    -g : user group (everyone in this group will have privileges over the given folder, as well as subfolders and files within.
    -d : directory to change permissions.
"
while getopts ":hg:d:" opt; do
  case $opt in
    h) echo "$usage"
       exit
    ;;
    g) group_id="$OPTARG"
    ;;
    d) dir="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

sudo chown -R :$group_id $dir 
sudo chmod -R g+rwxs $dir
sudo setfacl -d -m g::rwx $dir