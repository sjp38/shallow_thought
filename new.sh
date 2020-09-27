#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 3 ]
then
	echo "Usage: $0 [--date <date>] <text to log>"
	exit 1
fi

date=""
while true; do
	case $1 in
	"--date")
		date=$2
		shift 2
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

if [ ! -z "$date" ]
then
	export GIT_COMMITTER_DATE=$date
	export GIT_AUTHOR_DATE=$date
fi
git commit -m "$1" > /dev/null

if ! git push origin master
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
