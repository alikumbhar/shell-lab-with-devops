#!/bin/bash

<< readme

this is script for with 5 days rotation

Usage:
./backup.sh <source path> <path to backup folder>

readme

display_usage() {
echo "Usage: ./backup.sh <source path> <path to backup folder>"
}


if [ $# -eq 0 ]; then
	display_usage
fi

source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_dir=$2

create_backup() {
	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null
	if [ $? -eq 0] 
	then
		echo "backup created successfully"	
	fi
}


backup_rotation() {
	backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))
	if [ "${#backups[@]}" -gt 5 ]; then
		echo "Performing rotation for 5 days" 
		backups_to_remove=("${backups[@]:5}")
		for backup in "${backups_to_remove[@]}"; 
		do
		rm -f ${backup}
		done
	fi
}



create_backup
backup_rotation




