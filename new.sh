#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: $0 [options] <text to log>"
	echo "options:"
	echo "  --date <date>	Specify date of the thought"
	echo "  --no-sync	Do not sync with the remote storage"
	exit 1
fi

date=""
no_sync=false
while true; do
	case $1 in
	"--date")
		date=$2
		shift 2
		continue
		;;
	"--no-sync")
		no_sync=true
		shift 1
		continue
		;;
	*)
		break
		;;
	esac
done

msg=$1

echo "This will log your thought:"
echo "$msg"
echo
if [ ! -z "$date" ]
then
	echo "as thought at $date"
	echo
fi

tags=$(echo "$msg" | grep -o -E "#[a-zA-Z0-9_-]+" | tr '\n' ' ')
if [ ! -z "$tags" ]
then
	echo "found tags: $tags"
fi

read -rp "Okay? [Y/n] " answer
if [ "$answer" = "n" ]
then
	exit
fi

if ! $no_sync && ! git pull origin master
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

if [ ! -z "$date" ]
then
	export GIT_COMMITTER_DATE=$date
	export GIT_AUTHOR_DATE=$date
fi
git commit -m "$1" > /dev/null

if ! $no_sync && ! git push origin master
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
