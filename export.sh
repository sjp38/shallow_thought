#!/bin/bash

export_dir="st_exported"

mkdir -p "$export_dir"

nr_thoughts=$(git rev-list --count HEAD)
to_skip=0

for i in $(seq $((nr_thoughts - 1)) -1 0)
do
	to_skip=$((nr_thoughts - 1 - i))
	git_option="--skip=$to_skip --max-count=1"
	content="$(git log $git_option --pretty="%ad%n%n%B")"
	title=$(printf "%04d_" $i)
	title+="$(git log $git_option --pretty="%ad" --date=iso)"
	echo "$content" > "$export_dir/$title"
done

echo "The thoughts are exported in '$export_dir'"
