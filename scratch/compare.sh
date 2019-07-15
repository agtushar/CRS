for file in crs-complete/*.vhd; do diff -q "$file" "crs8/${file##*/}"; done

