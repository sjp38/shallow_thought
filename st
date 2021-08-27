#!/bin/bash

bindir=$(dirname "$0")

if [ $# -lt 1 ]
then
	echo "Usage: $0 <command> [command arguments]"
	echo
	echo "  commands:"
	for f in "$bindir"/*
	do
		if [ -x "$f" ]
		then
			command_name=$(echo $(basename "$f") | \
				awk -F'.sh' '{print $1}')
			if [ "$command_name" = "st" ] || \
				[[ "$command_name" = "_"* ]]
			then
				continue
			fi
			echo "    $command_name"
		fi
	done
	exit 1
fi

subcmd="$bindir/$1.sh"

if [ ! -x "$subcmd" ]
then
	echo "executable file $subcmd not found"
	exit 1
fi

shift

$subcmd "$@"
