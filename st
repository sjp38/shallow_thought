#!/bin/bash

bindir=$(dirname "$0")
commands="
    export		export thoughts to files
    import		import thoughts from files
    init		initialize with remote repository
    new			write new thought
    pull		pull thoughts from remote repository
    register_remote	register remote repository
    remove		remove recent thoughts
    restore_backup	restore backup thoughts
    show		show thoughts"

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
