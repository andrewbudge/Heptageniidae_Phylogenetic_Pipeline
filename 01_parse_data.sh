#!/bin/bash

source scripts/00_config.sh

header=$(head -n 1 "$ACC_CSV")
IFS=',' read -ra columns <<< "$header"

for i in "${!columns[@]}"; do
    if [ "$i" -ge 2 ]; then
        colname=$(echo "${columns[$i]}" | xargs)
        awk -F',' -v col=$((i+1)) 'NR > 1 { gsub(/^ +| +$/, "", $col); if ($col != "") print $col }' "$ACC_CSV" > "${ACC_LISTS}/${colname}.acc"
    fi
done

for file in "$ACC_LISTS"/*.acc; do
    sed -i 'y/:-/\t\t/' "$file"
done

