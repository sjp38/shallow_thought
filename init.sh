#!/bin/bash

git init
echo 0 > ./.ts

if [ $# -lt 1 ]
then
	echo "Usage: $0 <remote storage url>"
	exit 1
fi

REMOTE_URL="$1"
git remote add origin "$REMOTE_URL"
