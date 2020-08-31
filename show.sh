#!/bin/bash

nr_thoughts=$(git rev-list --count HEAD)
to_skip=0

if [ $# -eq 1 ] && [ "$1" = "--random" ]
then
	to_skip=$((RANDOM % nr_thoughts))
	nr_thoughts=1
fi
git log --pretty="%ad%n%n%B%n%n" --skip=$to_skip --max-count=$nr_thoughts
