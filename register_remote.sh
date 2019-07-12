#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <remote url>"
	exit 1
fi

git remote remove origin
git remote add origin $1
