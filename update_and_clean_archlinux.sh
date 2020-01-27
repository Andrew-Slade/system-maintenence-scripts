#!/bin/bash
#Copyright 2020, Andrew Slade, All rights reserved.

#
# Shell script to update arch linux then clean 
# the excess packages
# creates a log of update completion times and start times
#

this_dir=$(dirname "$0") #this files directory
LOG_FILE=${this_dir}/update.log # log file location
DATE=$(date) # current date
DIV="-------------------------------------------"

echo "Starting update"

# If the log does not exist, create it
# otherwise update computer
if [ -f "LOG_FILE" ]; then
  echo "Log file does not exist, creating..."
  touch ${LOG_FILE}
  echo "Update started at: " ${DATE} >> ${LOG_FILE}
  echo "Update started at: " ${DATE} 
  echo "${DIV}"
  sudo pacman -Syu --noconfirm 
  trizen -Syu --noconfirm --noedit
  sudo pacman -Sc #clear cache and unnecessary packages
  sudo pacman -R $(pacman -Qqtd) #clean orphaned packages
  echo "${DIV}"
  echo "Update finished at: " ${DATE} >> ${LOG_FILE}
else
  echo -e "Update started at: " ${DATE} >> ${LOG_FILE}
  echo -e "${DIV}\n"
  sudo pacman -Syu --noconfirm 
  trizen -Syu --noconfirm --noedit
  yes | sudo pacman -Sc #clear cache and unnecessary packages
  yes | sudo pacman -R $(pacman -Qqtd) #clean orphaned packages if needed
  echo ${DIV}
  echo "Update finished at: " ${DATE} >> ${LOG_FILE}
  echo "Update finished at: " ${DATE} 
fi
