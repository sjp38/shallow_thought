#!/bin/bash

if [ $# -ne 3 ]
then
	echo "Usage: $0 <date> <no_sync> <msg>"
	exit 1
fi

bindir=$(dirname "$0")
date=$1
no_sync=$2
msg=$3

if ! $no_sync
then
	echo
	echo "Pull remote thoughts"
	if ! "$bindir/_pull.sh"
	then
		echo "Sync failed"
		exit 1
	fi
fi

tags=$(echo "$msg" | grep -o -E "#\w+" | tr '\n' ' ')
tags+=" all"

if [ ! -d tags ]
then
	mkdir tags
fi

for tag in $tags
do
	tagfile="tags/$tag"
	if [ ! -e "$tagfile" ]
	then
		touch "$tagfile"
	fi
	nr_thoughts=$(( $(cat "$tagfile") + 1))
	echo $nr_thoughts > "$tagfile"
done

ts=$(( $(cat ./.ts) + 1))
echo $ts > ./.ts
git add ./.ts ./tags

if [ ! -z "$date" ]
then
	export GIT_COMMITTER_DATE=$date
	export GIT_AUTHOR_DATE=$date
fi
git commit -m "$msg" > /dev/null

if "$no_sync"
then
	exit 0
fi

echo
echo "Push the thought to remote"
if ! git push origin master
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
