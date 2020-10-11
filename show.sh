#!/bin/bash

function pr_usage {
	echo "Usage: $0 [OPTION]..."
	echo
	echo "OPTION"
	echo "  --random	Show random thought"
	echo "  --tags <tags>	Show thoughts of <tags>"
	echo "  --lstags	List existing tags and number of thoughts"
	echo "              	having each tag"
	echo " --backup <name>	Show thoughts in backup of <name>"
	echo "  --lsbackups	List backups of thoughts"
	echo "  -h, --help	Show this usage"
}

function ls_tags {
	for tag in tags/*
	do
		nr_thoughts=$(cat "$tag")
		tag_name=$(basename "$tag")
		echo "$tag_name $nr_thoughts"
	done
}

function ls_backups {
	git branch -r | awk -F'/' '{if ($2 != "master") print $2}'
}

random=false
while [ $# -ne 0 ]; do
	case "$1" in
	"--random")
		random=true
		shift 1
		continue
		;;
	"--tags")
		if [ $# -lt 2 ]
		then
			echo "<tags> not given"
			exit 1
		fi
		tags=$2
		shift 2
		continue
		;;
	"--lstags")
		ls_tags
		exit 0
		;;
	"--backup")
		if [ $# -lt 2 ]
		then
			echo "<name> not given"
			exit 1
		fi
		backup=$2
		shift 2
		continue
		;;
	"--lsbackups")
		ls_backups
		exit 0
		;;
	"--help")
		pr_usage
		exit 0
		;;
	"-h")
		pr_usage
		exit 0
		;;
	*)
		pr_usage
		exit 1
		;;
	esac
done

tags_option=""
for tag in $tags
do
	tags_option+=" tags/$tag"
done

if [ ! -z "$tags_option" ]
then
	tags_option=" -- $tags_option"
fi

nr_thoughts=$(git rev-list --count HEAD)
to_skip=0

if "$random"
then
	to_skip=$((RANDOM % nr_thoughts))
	nr_thoughts=1
fi
cmd="git log"
if [ "$backup" != "" ]
then
	cmd+=" origin/$backup"
	echo $cmd
fi
$cmd --pretty="%ad%n%n%B%n%n" --skip=$to_skip --max-count=$nr_thoughts \
	$tags_option
