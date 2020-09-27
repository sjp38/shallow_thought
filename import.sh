#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <thoughts dir>"
	exit 1
fi

to_import_dir=$1

BINDIR=$(dirname "$0")

echo "export current thoughts to $to_import_dir"
"$BINDIR/export.sh" "$to_import_dir"

to_import=$("$BINDIR/_verify_sort_thoughts.py" "$to_import_dir") || exit 1

echo "Initialize"
origin=$(git remote -v | grep origin | head -n 1 | awk '{print $2}')
rm -fr .git.bak
mv .git .git.bak
git init
echo "track $origin"
git remote add origin $origin

while IFS= read thought_file; do
	echo "import $thought_file"

	file="$to_import_dir/$thought_file"
	date=$(head -n 1 "$file")
	content=$(tail -n +3 "$file")
	"$BINDIR/_new.sh" "$date" true "$content"

done <<< "$to_import"

git push origin master --force
