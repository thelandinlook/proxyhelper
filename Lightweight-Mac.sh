#!/bin/bash

search_path="/path/to/your/MP4/files"

find "$search_path" -type f -name "*S03*.mp4" | while IFS= read -r file; do
    filename=$(basename "$file")
    new_filename=$(echo "$filename" | sed 's/S03//')
    new_path=$(dirname "$file")/"$new_filename"
    mv "$file" "$new_path"
    echo "Renamed file: $new_filename"
done

echo "All matching files renamed successfully."
