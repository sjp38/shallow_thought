#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <backup>"
	exit 1
fi

backup=$1

if ! git branch -r | grep --quiet "^  origin/$backup$"
then
	echo "Invalid backup"
	exit 1
fi

backup_current=$(date +%Y-%m-%d-%H-%M-%S)
echo "Backup current thoughts in name of $backup_current"
git branch "$backup_current"
git push origin "$backup_current"

if ! git reset --hard "origin/$backup"
then
	echo "Failed restoring $backup"
	exit 1
fi

echo
echo "Push restored thoughts"
git push origin master --force
