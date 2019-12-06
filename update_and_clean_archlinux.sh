#!/bin/bash


#
# Shell script to update arch linux then clean 
# the excess packages
# creates a log of update completion times and start times
#

LOG_FILE=${PWD}/update.log # log file location
DATE=$(date) # current date

echo "Starting update"

# If the log does not exist, create it
# otherwise update computer
if [ -f "LOG_FILE" ]; then
  echo "Log file does not exist, creating..."
  touch ${LOG_FILE}
  echo "Update started at: " $DATE >> $LOG_FILE
  sudo pacman -Syu --noconfirm 
  trizen -Syu --noconfirm --noedit
  sudo pacman -Sc #clear cache and unnecessary packages
  sudo pacman -R $(pacman -Qqtd) #clean orphaned packages
  echo "Update finished at: " $DATE >> $LOG_FILE
else
  echo -e "Update started at: " $DATE >> $LOG_FILE
  sudo pacman -Syu --noconfirm 
  trizen -Syu --noconfirm --noedit
  echo "Y" | sudo pacman -Sc #clear cache and unnecessary packages
  sudo pacman -R $(pacman -Qqtd) #clean orphaned packages
  echo "Update finished at: " $DATE >> $LOG_FILE
fi
