#!/bin/bash

# Overwrite the latest message

if ! git pull origin master
then
	echo "Failed to pull remote"
	exit 1
fi

if [ $# -ne 1 ]
then
	echo "Usage: $0 <text to log>"
	exit 1
fi

echo "This will overwrite"
echo "\`\`\`"
git log --pretty="%B" HEAD^..
echo "\`\`\`"
echo
echo "into"
echo
echo "\`\`\`"
echo "$1"
echo "\`\`\`"
echo
read -rp "Okay? [Y/n] " answer
if [ "$answer" = "n" ]
then
	exit
fi
git commit --amend -m "$1" > /dev/null

if ! git push origin master --force
then
	echo "Failed to push to remote.  Do push manually."
	exit 1
fi
