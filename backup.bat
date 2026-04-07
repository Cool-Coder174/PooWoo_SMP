@echo off
title PooWoo SMP - Backup
setlocal enabledelayedexpansion

:: Locale-independent timestamp via PowerShell (yyyyMMdd_HHmmss)
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TIMESTAMP=%%i"
set "BACKUP_DIR=backups\%TIMESTAMP%"
set "ERRORS=0"

echo =============================================
echo   PooWoo SMP - World Backup
echo =============================================
echo.
echo Backup destination: %BACKUP_DIR%
echo.

if not exist backups mkdir backups

mkdir "%BACKUP_DIR%"

echo [1/4] Backing up world...
if exist world (
    xcopy /E /I /Q world "%BACKUP_DIR%\world" >nul
    if !ERRORLEVEL! GEQ 2 (
        echo       FAILED - check disk space and permissions.
        set /a ERRORS+=1
    ) else (
        echo       Done.
    )
) else (
    echo       Skipped (not found).
)

echo [2/4] Backing up world_nether...
if exist world_nether (
    xcopy /E /I /Q world_nether "%BACKUP_DIR%\world_nether" >nul
    if !ERRORLEVEL! GEQ 2 (
        echo       FAILED - check disk space and permissions.
        set /a ERRORS+=1
    ) else (
        echo       Done.
    )
) else (
    echo       Skipped (not found).
)

echo [3/4] Backing up world_the_end...
if exist world_the_end (
    xcopy /E /I /Q world_the_end "%BACKUP_DIR%\world_the_end" >nul
    if !ERRORLEVEL! GEQ 2 (
        echo       FAILED - check disk space and permissions.
        set /a ERRORS+=1
    ) else (
        echo       Done.
    )
) else (
    echo       Skipped (not found).
)

echo [4/4] Backing up plugin configs (skipping .jar files)...
if exist plugins (
    robocopy plugins "%BACKUP_DIR%\plugins" /E /XF *.jar /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
    if !ERRORLEVEL! GEQ 8 (
        echo       FAILED - check disk space and permissions.
        set /a ERRORS+=1
    ) else (
        echo       Done.
    )
) else (
    echo       Skipped (not found).
)

:: Calculate total backup size via PowerShell
set "SIZE_STR=unknown"
for /f %%s in ('powershell -NoProfile -Command "[math]::Round((Get-ChildItem -Recurse '%BACKUP_DIR%' | Measure-Object -Sum Length).Sum / 1MB)"') do set "SIZE_STR=%%s MB"

echo.
if !ERRORS! gtr 0 (
    echo =============================================
    echo   Backup INCOMPLETE: !ERRORS! step(s^) failed
    echo   Location: %BACKUP_DIR%
    echo   Size: !SIZE_STR!
    echo =============================================
) else (
    echo =============================================
    echo   Backup complete: %BACKUP_DIR%
    echo   Size: !SIZE_STR!
    echo =============================================
)

:: Keep only the 5 most recent backups, delete older ones
echo.
echo Pruning old backups (keeping last 5)...
set "COUNT=0"
for /f "delims=" %%d in ('dir /B /AD /O-N backups 2^>nul') do (
    set /a COUNT+=1
    if !COUNT! gtr 5 (
        echo       Removing old backup: %%d
        rmdir /S /Q "backups\%%d"
    )
)
if !COUNT! leq 5 (
    echo       Nothing to prune.
) else (
    set /a REMOVED=!COUNT!-5
    echo       Removed !REMOVED! old backup(s).
)

echo.
echo TIP: Run "save-all" in the server console before backing up,
echo      or stop the server for a fully consistent backup.
echo.
pause
