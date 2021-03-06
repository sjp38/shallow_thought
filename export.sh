#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <export dir>"
	exit 1
fi

export_dir="$1"

mkdir -p "$export_dir"

nr_thoughts=$(git rev-list --count HEAD)
to_skip=0

for i in $(seq $((nr_thoughts - 1)) -1 0)
do
	to_skip=$((nr_thoughts - 1 - i))
	git_option="--skip=$to_skip --max-count=1"
	cmd="git log $git_option --pretty=\"%ad%n%n%B\""
	content=$(eval "$cmd")

	cmd="git log $git_option --pretty=\"%ad.%h\" --date=iso"
	title=$(eval "$cmd")

	thought_file="$export_dir/$title"
	if [ -f "$thought_file" ]
	then
		echo "$thought_file exists"
		exit 1
	fi

	echo "$content" > "$thought_file"
done

echo "The $nr_thoughts thoughts are exported in '$export_dir/'"
