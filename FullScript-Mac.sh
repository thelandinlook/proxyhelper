config_file_path="config.txt"

if [ -f "$config_file_path" ]; then
    IFS=$'\n' read -d '' -r -a lines < "$config_file_path"
    prev_dir="${lines[0]}"

    echo "Previous directory was: $prev_dir"
    read -p "Would you like to use the previous directory? (hit ENTER for yes or paste a new directory)" dest_directory
    [ -z "$dest_directory" ] && dest_directory=$prev_dir
else
    read -p "Enter the destination directory" dest_directory
fi

read -p "Enter the absolute base directory containing PRIVATE/M4ROOT folders" base_directory

echo "$dest_directory" > $config_file_path

src_folders=("$base_directory/PRIVATE/M4ROOT/CLIP/*" "$base_directory/PRIVATE/M4ROOT/SUB/*")

for src_folder in "${src_folders[@]}"; do
    if [ ! -d "$(dirname ${src_folder})" ]; then
        echo "No files found in $src_folder. Skipping ..."
        continue
    fi

    dest_folder="$dest_directory"
    if [[ "$src_folder" == "$base_directory/PRIVATE/M4ROOT/SUB/*" ]]; then
        dest_folder="$dest_directory/Proxy"
    fi

    if [ ! -d "$dest_folder" ]; then
        mkdir -p "$dest_folder"
    fi

    for file in $src_folder; do
        new_name=$(basename "$file")

        if [[ "$src_folder" == "$base_directory/PRIVATE/M4ROOT/SUB/*" ]]; then
            if [[ "$new_name" =~ S03 ]] ; then
                new_name=${new_name/S03/}
                mv "$file" "$(dirname $file)/$new_name"
            fi
        fi

        if [ ! -f "$dest_folder/$new_name" ]; then
            cp "$file" "$dest_folder/$new_name"
        fi
    done
    echo "File copy operation was successful! $src_folder"
done

read -p "Would you like to delete the original files from ${src_folders[*]}? (hit ENTER for no or type Y for yes)" choice
if [ "$choice" == "Y" ]; then
    for src_folder in "${src_folders[@]}"; do 
        if [ -d "$(dirname $src_folder)" ]; then
            rm -rf "${src_folder}"
            echo "Files removed successfully from $src_folder"
        fi
    done
fi
