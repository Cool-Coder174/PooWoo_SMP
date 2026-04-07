@echo off
:: PooWoo SMP — shared configuration.
:: All batch scripts source this file via:  call "%~dp0config.bat"
::
:: Override any value by setting the environment variable before running
:: a script (e.g. set "JAVA_HOME=D:\jdk21" && start.bat).

:: --- Java ---
:: Prefer Java 25 (required by Paper 1.21+), fall back to JAVA_HOME / PATH
if exist "C:\Program Files\Amazon Corretto\jdk25.0.2_10\bin\java.exe" (
    set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk25.0.2_10"
) else if not defined JAVA_HOME (
    for /f "tokens=*" %%j in ('where java 2^>nul') do (
        for %%p in ("%%~dpj..") do set "JAVA_HOME=%%~fp"
    )
)

:: --- Google Cloud SDK ---
if not defined GCLOUD_SDK (
    if exist "%LOCALAPPDATA%\Google\Cloud SDK\google-cloud-sdk" (
        set "GCLOUD_SDK=%LOCALAPPDATA%\Google\Cloud SDK\google-cloud-sdk"
    ) else if exist "%ProgramFiles%\Google\Cloud SDK\google-cloud-sdk" (
        set "GCLOUD_SDK=%ProgramFiles%\Google\Cloud SDK\google-cloud-sdk"
    ) else if exist "%ProgramFiles(x86)%\Google\Cloud SDK\google-cloud-sdk" (
        set "GCLOUD_SDK=%ProgramFiles(x86)%\Google\Cloud SDK\google-cloud-sdk"
    )
)

set "PATH=%JAVA_HOME%\bin;%PATH%"
if defined GCLOUD_SDK set "PATH=%GCLOUD_SDK%\bin;%PATH%"

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo [!] WARNING: java.exe not found at %JAVA_HOME%\bin\java.exe
    echo     Set JAVA_HOME to your Java installation directory.
)

set "TUNNEL_WAIT=15"
set "GCP_RELAY_IP=34.71.32.17"
set "GCP_VM_NAME=poowoo-relay"
set "GCP_ZONE=us-central1-a"
set "SERVER_RAM=16384"
set "SERVER_JAR=server.jar"
set "JAVA_CMD=java -Xms%SERVER_RAM%M -Xmx%SERVER_RAM%M -XX:+UseZGC -jar %SERVER_JAR% --nogui"
