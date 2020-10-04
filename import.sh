#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: $0 <thought> [<thought> ...]"
	exit 1
fi

if ! tmpdir=$(mktemp -d st_import_dir.XXXX)
then
	echo "Failed mktemp"
	exit 1
fi

cp "${@:1}" "$tmpdir/"

to_import_dir="$tmpdir"

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

rm -fr "$to_import_dir"
