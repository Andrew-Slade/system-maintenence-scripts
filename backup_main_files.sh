#!/bin/bash

#usually named backup.sh

#copies:
# All of documents folder, .bashrc, .vimrc, backup.sh, iptables.rules
# ip6tables.rules, .ssh config, an update and backup script
#creates:
# A Directory if !exists, a log of all installed programs
# creates the backup in the working dir

DIR=${PWD}/Backup
div='------------------------------------'
RSYNC=$(sudo pacman -Q | grep rsync | cut -d " " -f 1)
UPDATE_SCRIPT=update_archlinux.sh
BACKUP_SCRIPT=${0##*/} #this script
SCREEN_TEAR_SCRIPT=screen_tear_nvidia.sh

if [ "${RSYNC}" != "rsync" ]; then
  echo "Installing rsync"
  sudo pacman -S rsync
fi

if
 test -d ${DIR};
then
 echo "${DIR} exists...proceeding";
 yes | rm -R ${DIR}/* #remove all files in backup
else
 echo "${DIR} does not exist... creating ${DIR}";
 mkdir ${DIR} #create backup
fi

# rsync used for documents directories
echo "${DIV}" 
echo "syncing documents..."
rsync -rv ~/Documents/ ${DIR}
rsync -rv ~/Projects/ ${DIR}
rsync -rv ~/Pictures ${DIR}
echo "finished syncing documents..."
echo "${DIV}"

# copies over bashrc, iptables, ip6tables, backup script, and vimrc
echo "copying important files..."
cp -v ~/.bashrc ${DIR}/bashrc.cpy
cp -v ~/.vimrc ${DIR}/vimrc.cpy
cp -v ~/${BACKUP_SCRIPT} ${DIR}/${BACKUP_SCRIPT}
cp -v /etc/iptables/iptables.rules ${DIR}/iptables.rules
cp -v ~/${SCREEN_TEAR_SCRIPT} ${DIR}/${SCREEN_TEAR_SCRIPT}
cp -v /etc/iptables/ip6tables.rules ${DIR}/ip6tables.rules
cp -v ~/.ssh/config ${DIR}/config
cp -v ~/${UPDATE_SCRIPT} ${DIR}/${UPDATE_SCRIPT}
echo "finished copying important files"
echo "${DIV}"

#create a log of all installed programs
echo "preparing installation backups..."
sudo pacman -Qqe > ${DIR}/pacmanInstall.log
echo "pacman log created..."
trizen -Qqe > ${DIR}/trizenInstall.log
echo "trizen log created..."
echo "${DIV}"
#to reinstall: pacman -S --needed - < pkglist.txt

#log of all enabled programs
echo "logging enabled services..."
touch ${DIR}/enabled.log
sudo systemctl list-unit-files | grep enabled | tee > ${DIR}/enabled.log 
echo "enabled services logged..."
echo "${DIV}"
