@echo off
:: PooWoo SMP — shared configuration.
:: All batch scripts source this file via:  call "%~dp0config.bat"
::
:: Override any value by setting the environment variable before running
:: a script (e.g. set "JAVA_HOME=D:\jdk21" && start.bat).

if not defined JAVA_HOME  set "JAVA_HOME=C:\Program Files\Amazon Corretto\jdk25.0.2_10"
if not defined GCLOUD_SDK set "GCLOUD_SDK=C:\Users\isaac\AppData\Local\Google\Cloud SDK\google-cloud-sdk"

set "PATH=%JAVA_HOME%\bin;%GCLOUD_SDK%\bin;%PATH%"

set "GCP_RELAY_IP=34.71.32.17"
set "GCP_VM_NAME=poowoo-relay"
set "GCP_ZONE=us-central1-a"
set "SERVER_RAM=16384"
set "SERVER_JAR=server.jar"
