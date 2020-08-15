#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <text to log>"
	exit 1
fi

echo "This will log your thought:"
echo "$1"
echo
read -p "Okay? [Y/n] " answer
if [ "$answer" = "n" ]
then
	exit
fi

git pull origin master
if [ $? -ne 0 ]
then
	echo "Failed to pull remote"
	exit 1
fi

ts=$(( `cat ./.ts` + 1))
echo $ts > ./.ts
git add ./.ts
git commit -m "$1" > /dev/null

git push origin master
if [ $? -ne 0 ]
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
