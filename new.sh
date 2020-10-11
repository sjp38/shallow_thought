#!/bin/bash

BINDIR=$(dirname "$0")

function pr_usage {
	echo "Usage: $0 [options] <text to log>"
	echo "options:"
	echo "  --date <date>	Specify date of the thought"
	echo "  --no-sync	Do not sync with the remote storage"
	echo "  -h, --help	Show this usage"
}

if [ $# -lt 1 ]
then
	pr_usage
	exit 1
fi

date=""
no_sync=false
while [ $# -ne 0 ]; do
	case $1 in
	"--date")
		if [ $# -lt 2 ]
		then
			echo "<date> not given"
			pr_usage
			exit 1
		fi
		date=$2
		shift 2
		continue
		;;
	"--no-sync")
		no_sync=true
		shift 1
		continue
		;;
	"--help" | "-h")
		pr_usage
		exit 0
		;;
	*)
		if [ $# -ne 1 ]
		then
			pr_usage
			exit 1
		fi
		msg=$1
		break
		;;
	esac
done

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
