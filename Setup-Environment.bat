@echo off

if "%~1"=="" (
    echo Environment name is required. Use "Setup-Environment.bat [environment]"
    pause
    exit
)

set batchDir=%CD%
set environmentDir=%batchDir%\environments
set environmentScript=%environmentDir%\%1.ps1
set installPackageScript=%batchDir%\scripts\Install-EnvironmentPackage.ps1
set createPowershellProfileScript=%batchDir%\scripts\Create-PowershellProfile.ps1
set packageName=tp.%1

echo Checking environment...
if not exist %environmentScript% (
    echo Can not find environment name "%1".
    pause
    exit
)

echo Checking admin privileges...
net session >nul 2>&1
if errorlevel 1 (
    echo Admin privileges are required to run this script.
    pause
    exit
)

echo Checking powerShell profile...
PowerShell -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%createPowershellProfileScript%\"' -Verb RunAs}"

where /q choco
if errorlevel 1 (
    echo Installing Chocolatey
    set errorlevel=0
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)

where /q boxstarter
if errorlevel 1 (
    echo Installing Boxstarter
    set errorlevel=0
    choco install boxstarter -y
)

echo Preparing and installing environment package %packageName%...
PowerShell -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%installPackageScript%\" \"%environmentScript%\" \"%packageName%\"' -Verb RunAs}"