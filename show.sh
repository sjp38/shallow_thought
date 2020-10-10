#!/bin/bash

function pr_usage {
	echo "Usage: $0 [OPTION]..."
	echo
	echo "OPTION"
	echo "  --random	Show random thought"
	echo "  --tags <tags>	Show thoughts of <tags>"
	echo "  -h, --help	Show this usage"
}

random=false
while true; do
	case "$1" in
	"--random")
		random=true
		shift 1
		continue
		;;
	"--tags")
		tags=$2
		shift 2
		continue
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
		break
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
git log --pretty="%ad%n%n%B%n%n" --skip=$to_skip --max-count=$nr_thoughts \
	$tags_option
