#!/bin/bash

bindir=$(dirname "$0")
commands="
    init		initialize with remote repository
    new			write new thought
    show		show thoughts
    remove		remove recent thoughts
    export		export thoughts to files
    import		import thoughts from files
    register_remote	register remote repository
    pull		pull thoughts from remote repository
    restore_backup	restore backup thoughts"

if [ $# -lt 1 ]
then
	echo "Usage: $0 <command> [command arguments]"
	echo
	echo -n "  commands:"
	echo "$commands"
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
