$drives = Get-PSDrive -PSProvider 'FileSystem' | Select-Object -ExpandProperty Name
Write-Host "Available drives are: $($drives -join ', ')"

$config_file_path = Join-Path $PSScriptRoot "config.txt"

if (Test-Path $config_file_path) {
    $config = Get-Content $config_file_path
    $prev_drive = $config[0]
    Write-Host "Previous drive was: $prev_drive"
    $drive = Read-Host "Would you like to use the previously selected SD card drive? (hit ENTER for yes or type a new drive)"
    if ([string]::IsNullOrWhitespace($drive)) { 
        $drive = $prev_drive 
    }

    $prev_dir = $config[1]
    Write-Host "Previous directory was: $prev_dir"
    $dest_directory = Read-Host "Would you like to use the previous directory? (hit ENTER for yes or paste a new directory)"
    if ([string]::IsNullOrWhitespace($dest_directory)) { $dest_directory = $prev_dir }
} else {
    $drive = Read-Host "Enter the SD card's drive letter (without colon) containing the 'PRIVATE\M4ROOT' folders"
    $dest_directory = Read-Host "Enter the destination directory"
}

$config_data = "$drive`n$dest_directory"
Set-Content -Path $config_file_path -Value $config_data

$src_folders = @{
    "CLIP" = "$($drive):\PRIVATE\M4ROOT\CLIP\*"
    "SUB"  = "$($drive):\PRIVATE\M4ROOT\SUB\*"
}

foreach ($src_folder in $src_folders.GetEnumerator()) {
    if (-not(Test-Path $src_folder.Value)) {
        Write-Host "No files found in $($src_folder.Value)"
        continue
    }
    $dest_folder = $dest_directory.TrimEnd('\') 
    if ($src_folder.Name -eq "SUB") {
        $dest_folder = Join-Path $dest_directory "Proxy"
    }

    if (-not (Test-Path $dest_folder)) { New-Item -ItemType Directory -Force -Path $dest_folder }

    try {
        Get-ChildItem -Path $src_folder.Value |
        ForEach-Object {
            $new_name = $_.FullName
            if ($src_folder.Name -eq "SUB") {
                $_ | Where-Object { $_.Name -match 'S03' } |
                ForEach-Object {
                    $new_name = $_.Name.Replace('S03','')
                    Rename-Item -Path $_.FullName -NewName $new_name
                }
            }
            
            $dest_file = Join-Path $dest_folder $(Split-Path $new_name -Leaf)
            if (-not (Test-Path $dest_file)) {
                Copy-Item -Path $_.FullName -Destination $dest_file -ErrorAction Stop
            }
        }        
        Write-Host "File copy operation was successful! $($src_folder.Value)"
    }
    catch {
        Write-Host "File copy operation failed in $($src_folder.Value)"
    }
}

$choice = Read-Host "Would you like to delete the original files from $($src_folders.Values)? (hit ENTER for no or type Y for yes)"
if ($choice.ToUpper() -eq 'Y') {
    foreach ($src_folder in $src_folders.GetEnumerator()) {
        if (Test-Path $src_folder.Value) {
            Remove-Item -Path $src_folder.Value -Force
            Write-Host "Files removed successfully from $($src_folder.Value)"
        }
    }
}
