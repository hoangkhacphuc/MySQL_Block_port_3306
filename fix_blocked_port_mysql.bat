@REM            Issue: Fix blocked port 3306 for MySQL
@REM            Author: Hoang Khac Phuc
@REM            Contact: fb.com/hoangkhacphuc.dev
@REM            Date: 14-02-2023
@REM            Version: 1.0
@REM            Description:    This script will fix the blocked port 3306 for MySQL.
@REM                            - Check if MySQL is running.
@REM                            - Check if port 3306 is blocked.
@REM                            - Check if current location is \xampp\mysql.
@REM                            - Check if folder './data_old' exists and delete it.
@REM                            - Rename folder './data' to './data_old'.
@REM                            - Copy folder './backup' to './data'.
@REM                            - Delete file 'ibdata1' in './data'.
@REM                            - Create file 'exclude_folders.txt' to exclude default folders contained in folder './backup'.
@REM                            - Create a folder './data2' to contain the folders that need to be converted to './data' temporarily.
@REM                            - Create file 'list_folders.txt' to save list of folders in './data_old'.
@REM                            - Get the list of folders in './data_old' and save to file 'list_folders.txt'.
@REM                            - Copy folders from './data_old' to './data2' except the folders in 'exclude_folders.txt'.
@REM                            - Copy folders from './data2' to './data' except the folders in 'exclude_folders.txt'.
@REM                            - Delete folder './data2'.
@REM                            - Delete file 'exclude_folders.txt' and 'list_folders.txt'.


@echo off
setlocal EnableDelayedExpansion
TITlE Fixing blocked port 3306 for MySQL
cls

REM Check if MySQL is running
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I "mysqld.exe" >NUL

REM If MySql is running then please shut it down
if ERRORLEVEL 1 (
    echo Checked: MySQL is not running.
) else (
    echo Checked: MySQL is running. Turn it off and do it again.
    echo.
    pause
    exit /b  
)

REM Check if port 3306 is blocked
netstat -aon | find /I "3306" >NUL

REM If port 3306 is blocked then please unblock it
if ERRORLEVEL 1 (
    echo Checked: Port 3306 is not blocked.
) else (
    echo Checked: Port 3306 is blocked. Unblock it and do it again.
    echo.
    echo To check, perform the following steps:
    echo.
    echo Step 1: Open Command Prompt [cmd] and run the following command 'netstat -aon'.
    echo Step 2: Search in the 'Local Address' column for the IP address that is using Port 3306.
    echo         For example: '0.0.0.0:3306', '127.0.0.1:3306', '192.168.0.0:3306', ...
    echo Step 3: Once port 3306 is found, check its PID and search in 'Task Manager' to turn it off.
    echo.
    pause
    exit /b  
)

REM Check if current location is \xampp\mysql
if exist ".\backup" (
    echo Checked: Current location is \xampp\mysql.
) else (
    echo Checked: Current location is not \xampp\mysql. Please run this script in \xampp\mysql.
    echo.
    pause
    exit /b    
)

REM Check if folder './data_old' exists and delete it
if exist ".\data_old" (
    goto :confirm
) else (
    echo Checked: Folder './data_old' does not exist.
    goto :renameFolderDataOld
)

:confirm
    echo Checked: Folder './data_old' exists. Are you sure to delete it?
    set /p input=Type 'Y' to confirm:
    if /i "%input%"=="Y" (
        rmdir /s /q ".\data_old"
        echo Folder './data_old' has been deleted.
        goto :renameFolderDataOld
    ) else (
        echo Checked: Folder './data_old' has not been deleted.
        echo.
        pause
        exit /b  
    )

:renameFolderDataOld
    REM Rename folder './data' to './data_old'
    echo Renaming folder './data' to './data_old'...
    ren ".\data" "data_old"
    if ERRORLEVEL 1 (
        echo Checked: Folder './data' has not been renamed to './data_old'.
        echo.
        pause
        exit /b  
    )
    echo Checked: Folder './data' has been renamed to './data_old'.
    goto :dataMigration

:dataMigration
    REM Copy folder './backup' to './data'
    echo Copying folder './backup' to './data'...
    xcopy ".\backup" ".\data" /E /I /Y /Q
    if ERRORLEVEL 1 (
        echo Checked: Folder './backup' has not been copied to './data'.
        echo.
        pause
        exit /b  
    )
    echo Checked: Folder './backup' has been copied to './data'.

    REM Delete file 'ibdata1' in './data'
    echo Deleting file 'ibdata1' in './data'...
    del ".\data\ibdata1"
    if ERRORLEVEL 1 (
        echo Checked: File 'ibdata1' has not been deleted.
        echo.
        pause
        exit /b  
    )
    echo Checked: File 'ibdata1' has been deleted.

    REM Create file 'exclude_folders.txt' to exclude folders in './data_old' from copying to './data'
    if exist ".\exclude_folders.txt" (
        echo Checked: File 'exclude_folders.txt' exists.
        echo Deleting file 'exclude_folders.txt'...
        del ".\exclude_folders.txt"
    ) else (
        echo Checked: File 'exclude_folders.txt' does not exist.
    )
    echo Creating file 'exclude_folders.txt' to exclude folders in './data_old' from copying to './data'...
    echo mysql > ".\exclude_folders.txt"
    echo performance_schema >> ".\exclude_folders.txt"
    echo phpmyadmin >> ".\exclude_folders.txt"
    echo test >> ".\exclude_folders.txt"
    if ERRORLEVEL 1 (
        echo Checked: File 'exclude_folders.txt' has not been created.
        echo.
        pause
        exit /b  
    )
    echo Checked: File 'exclude_folders.txt' has been created.

    REM Create folder './data2'
    echo Creating folder './data2'...
    mkdir ".\data2"
    if ERRORLEVEL 1 (
        echo Checked: Folder './data2' has not been created.
        echo.
        pause
        exit /b  
    )
    echo Checked: Folder './data2' has been created.

    REM Create file 'list_folders.txt' to save list of folders in './data_old'
    if exist ".\list_folders.txt" (
        echo Checked: File 'list_folders.txt' exists.
        echo Deleting file 'list_folders.txt'...
        del ".\list_folders.txt"
    ) else (
        echo Checked: File 'list_folders.txt' does not exist.
    )

    REM Get the list of folders in './data_old' and save to file 'list_folders.txt'
    dir ".\data_old" /b /ad > ".\list_folders.txt"
    if ERRORLEVEL 1 (
        echo Checked: File 'list_folders.txt' has not been created.
        echo.
        pause
        exit /b  
    )
    echo Checked: File 'list_folders.txt' has been created.

    REM Copy all folders named in file 'list_folders.txt' to './data2'
    for /f "tokens=*" %%a in (.\list_folders.txt) do (
        xcopy ".\data_old\%%a" ".\data2\%%a" /E /I /Y /Q
    )

    REM Delete the folders in './data2' named in the file 'exclude_folders.txt'
    for /f "tokens=*" %%a in (.\exclude_folders.txt) do (
        rmdir /s /q ".\data2\%%a"
    )

    REM Copy all folders in './data2' to './data'
    for /f "tokens=*" %%a in (.\list_folders.txt) do (
        xcopy ".\data2\%%a" ".\data\%%a" /E /I /Y /Q
    )

    REM Delete folder './data2'
    rmdir /s /q ".\data2"

    REM Replace file ibdata1 trong './data_old' vào './data'
    echo Replacing file ibdata1 in './data_old' to './data'...
    copy ".\data_old\ibdata1" ".\data\ibdata1" /Y
    if ERRORLEVEL 1 (
        echo Checked: File ibdata1 has not been replaced.
        echo.
        pause
        exit /b  
    )
    echo Checked: File ibdata1 has been replaced.

    REM Delete file 'exclude_folders.txt' and 'list_folders.txt'
    del ".\exclude_folders.txt"
    del ".\list_folders.txt"

    echo.
    echo.
    echo ===========================================================
    echo                        Completed^^!
    echo    Error has been fixed, now you can start MySQL to use.
    echo ===========================================================
    echo                                         by: Hoang Khac Phuc
echo.
pause    