#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: $0 <command> [command arguments]"
	exit 1
fi

BINDIR=$(dirname "$0")

subcmd="$BINDIR/$1.sh"

if [ ! -x $subcmd ]
then
	echo "executable file $subcmd not found"
	exit 1
fi

shift

$subcmd "$@"
