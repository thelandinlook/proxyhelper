@echo off
setlocal enabledelayedexpansion

set "searchPath=C:\Path\to\your\MP4\files"

for /r "%searchPath%" %%F in (*.mp4) do (
    set "filename=%%~nF"
    set "extension=%%~xF"

    if "!filename:S03=!" neq "!filename!" (        
        set "newFilename=!filename:S03=!"
        ren "%%F" "!newFilename!!extension!"
        echo Renamed file: "%%~nxF"
    )
)

echo All matching files renamed successfully.

pause
