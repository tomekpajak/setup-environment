#Boxstarter variables
$Boxstarter.RebootOk = $false
$Boxstarter.NoPassword = $false
$Boxstarter.AutoLogin = $true

#Configuring choco
$chocoCacheDir = "c:\temp\chocoCache"
New-item -Type Directory -path $chocoCacheDir
choco config set cacheLocation $chocoCacheDir
choco feature enable -n=allowGlobalConfirmation

$computerName = "TP-X360-Test1"

Write-Host "Check logs in "$Boxstarter.Log

#Windows Settings
Disable-GameBarTips
Disable-BingSearch
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableExpandToOpenFolder
Set-TaskbarOptions -Size Small -Dock Bottom -Combine Always -AlwaysShowIconsOn
# Privacy: Let apps use my advertising ID: Disable
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0
# Disable Telemetry (requires a reboot to take effect)
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWord -Value 0
Get-Service DiagTrack,Dmwappushservice | Stop-Service | Set-Service -StartupType Disabled
# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1
# Change Windows Updates to "Notify to schedule restart"
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name UxOption -Type DWord -Value 1

#Uninstall store-installed apps
##List all store-installed apps
##Get-AppxPackage | Where-Object NonRemovable -eq $false | sort -property Name | Select-Object Name, PackageFamilyName, Version | Format-Table -AutoSize
Write-Host "Removing pre-installed apps..."
Get-AppxPackage | Where-Object {$_.name -Match "AdobePhotoshopExpress|GetHelp|Getstarted|Microsoft3DViewer|MixedReality.Portal|People|SkypeApp|windowscommunicationsapps|WindowsFeedbackHub|WindowsMaps|Xbox.TCUI|XboxApp|XboxGameOverlay|XboxGamingOverlay|XboxSpeechToTextOverlay|Microsoft.Wallet|Microsoft.MicrosoftOfficeHub|MicrosoftSolitaireCollection|Microsoft.Office.OneNote|XboxIdentityProvider"} | Remove-AppxPackage -ea 0

#Rename the computer name
if ($env:computername -ne $computername) {Rename-Computer -NewName $computername}

#WSL
cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst wsl
if (Test-PendingReboot) 
{
    $Boxstarter.RebootOk=$true
    Invoke-Reboot
}
cinst wsl2
cinst lxrunoffline

# Set directory for installation - Chocolatey does not lock
# down the directory if not the default
$installDir="C:\ProgramData\chocoapps"
$env:ChocolateyInstall="$installDir"

#apps
cinst adobereader -params '"/NoUpdates"'
cinst adobeair
cinst keepass
cinst office2019proplus --params '/Language:pl-PL'
cinst calibre #shortcut

cinst 7zip
cinst adobereader
cinst googlechrome #shortcut
cinst microsoft-edge #shortcut
cinst firefox #shortcut
cinst notepadplusplus
cinst powertoys
cinst todobackup
cinst totalcommander
cinst rufus
cinst etcher
cinst cpu-z  #shortcut
cinst processhacker  #shortcut
cinst disk2vhd
cinst treesizefree

cinst kdiff3
cinst postman #shortcut
cinst fiddler
#cinst zap
cinst winscp  #shortcut
cinst mkcert
cinst powershell-core
cinst microsoft-windows-terminal
cinst azure-data-studio
cinst linqpad
cinst sysinternals --params "/InstallDir:c:\tools\sysinternals"
cinst git --params '/GitOnlyOnPath /NoShellIntegration'
cinst vscode --params '/NoQuicklaunchIcon' #shortcut
cinst vscode-settingssync
cinst docker-desktop  #shortcut
cinst nswagstudio
cinst nmap
cinst iperf3
cinst wireshark

#Ssh client on windows 10
Add-WindowsCapability -Online -Name OpenSSH.Client*

#Power Settings 
powercfg /h on
powercfg -change -monitor-timeout-ac 10
powercfg -change -monitor-timeout-dc 5
powercfg -change -standby-timeout-ac 30
powercfg -change -standby-timeout-dc 15
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0

#MicrosoftUpdate
Enable-MicrosoftUpdate
Install-WindowsUpdate -GetUpdatesFromMS -AcceptEula

#Cleaning
choco feature disable -n=allowGlobalConfirmation
Remove-item -Recurse $chocoCacheDir -force

# # Install Visual Studio Code Extensions
# code --install-extension ms-vscode.csharp
# code --install-extension ms-vscode.Go
