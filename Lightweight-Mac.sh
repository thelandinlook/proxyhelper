#!/bin/bash

# Counter variable
count=0

# Find all files in current directory and sub directories
for file in $(find . -type f -name '*S03*')
do
    # Rename the files and delete 'S03' from their names
    new_name=${file/'S03'/}
    mv "$file" "$new_name"

    # Increase counter
    ((count++))
done

# Print out how many files were renamed
echo "$count files were renamed."
