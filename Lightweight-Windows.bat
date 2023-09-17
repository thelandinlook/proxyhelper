@echo off
setlocal enabledelayedexpansion

:: Initialize counter
set /a count=0

:: Lines with 'for /r' walks through the directory tree
for /r %%F in (*S03*) do (

    :: %%~nF extracts the name part of the full path stored in %%F
    set "name=%%~nF"

    :: Verify if the file name has changed
    if not "!name:S03=!" == "%%~nF" (
        :: This line does the actual renaming. A simple string substitution is performed to remove 'S03' from the file name.
        ren "%%F" "!name:S03=%%~xF!"

        :: Increase counter
        set /a count+=1
    )
)

:: Print out how many files were renamed
echo !count! files were renamed.

pause
