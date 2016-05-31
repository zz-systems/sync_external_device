#!/bin/bash
#
#-----------------------------------------------------------------------
#
# Script to backup all needed data upon USB hard disk insertion
# and mount through file manager (tested with gnome files)
# It is called through systemd with :
#  - the device name (anything, just for logging) given as the first parameter
#  - the device mountpoint (f.e /run/media/user/STICK/)
#
#-----------------------------------------------------------------------

# source ini parser
DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/bash_ini_parser/read_ini.sh"

device_name=$1
#trim trailing slash
device_mount_point=${2%/}

if [ ! -f "$device_mount_point/.foldersync" ]; then
		logger SyncExt - sync $device_name - failed - no .foldersync at `date`;
		return;
fi

# Log beggining of sync
logger SyncExt - sync $device_name - beginning at `date`
notify-send 'SyncExt' "Sync for ${device_name} started." --icon=dialog-information

# read mapping file
read_ini $device_mount_point/.foldersync

# sync for each mapped folder
for section in ${INI__ALL_SECTIONS}
do
	echo "For section '$section' :"
	SYNC_REMOTE="INI__${section}__Remote"
	SYNC_LOCAL="INI__${section}__Local"

	# if local/remote target is missing, skip it
	if [ -z ${!SYNC_REMOTE+x} ] || [ -z ${!SYNC_LOCAL+x} ]; then
		logger "Missing remote/local target";
		continue;
	fi

	SYNC_REMOTE="$device_mount_point/${!SYNC_REMOTE}/"
	SYNC_LOCAL="${!SYNC_LOCAL}/"

	#echo "syncing between $SYNC_REMOTE and $SYNC_LOCAL"
	unison $SYNC_REMOTE $SYNC_LOCAL -fat -times -owner -group -prefer $SYNC_LOCAL -auto -batch
done

# force sync of files
/bin/sync

# Log end of backup
logger SyncExt sync - end at `date`
notify-send 'SyncExt' "Sync for ${device_name} finished." --icon=dialog-information
