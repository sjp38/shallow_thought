#!/bin/bash

if [ $# -gt 1 ]
then
	echo "Usage: $0 <number of thoughts to remove>"
	exit 1
fi

nr_thoughts=1
if [ $# -eq 1 ]
then
	nr_thoughts=$1
fi

nr_total_thoughts=$(git rev-list --count HEAD)

if [ "$nr_thoughts" -ge "$nr_total_thoughts" ]
then
	echo "There are only $nr_total_thoughts (<= $nr_thoughts)"
	exit 1
fi

echo "This will remove $nr_thoughts previous thoughts."
echo "Note: This will not sync with your remote before making the change"
read -rp "Are you sure? [N/y] " answer
if [ "$answer" != "y" ]
then
	echo "canceled."
	exit
fi

git reset --hard "HEAD~$nr_thoughts"

if ! git push origin master --force
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
