#!/bin/bash

git init
echo 0 > ./.ts

if [ $# -lt 1 ]
then
	exit
fi

REMOTE_URL=$1
git remote add origin $REMOTE_URL
