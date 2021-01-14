#!/bin/bash

git fetch origin

if ! git merge origin/master
then
	backup=$(date +%Y-%m-%d-%H-%M-%S)
	echo "Local thoughts will be backed up as $backup"
	git branch "$backup"
	git push origin "$backup"
	git reset --hard origin/master
fi
