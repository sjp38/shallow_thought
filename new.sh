#!/bin/bash

BINDIR=$(dirname "$0")

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

"$BINDIR/_new.sh" "$date" $no_sync "$msg"
