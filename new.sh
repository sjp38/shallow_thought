#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <text to log>"
	exit 1
fi

msg=$1

echo "This will log your thought:"
echo "$msg"
echo

tags=$(echo "$msg" | grep -o -E "#[a-zA-Z0-9_-]+" | tr '\n' ' ')
echo "found tags: $tags"

read -rp "Okay? [Y/n] " answer
if [ "$answer" = "n" ]
then
	exit
fi

if ! git pull origin master
then
	echo "Failed to pull remote"
	exit 1
fi

tags+=" all"

if [ ! -d tags ]
then
	mkdir tags
fi

for tag in $tags
do
	tagfile="tags/$tag"
	if [ ! -e $tagfile ]
	then
		touch $tagfile
	fi
	nr_thoughts=$(( $(cat $tagfile) + 1))
	echo $nr_thoughts > $tagfile
done

ts=$(( $(cat ./.ts) + 1))
echo $ts > ./.ts
git add ./.ts ./tags
git commit -m "$1" > /dev/null

if ! git push origin master
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
