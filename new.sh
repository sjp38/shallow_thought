#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <text to log>"
	exit 1
fi

ts=$(( `cat ./.ts` + 1))

echo $ts > ./.ts

git add ./.ts
git commit -m "$1" > /dev/null
