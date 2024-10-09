echo("")
echo("=============================================================")
echo("=== Windows 11 Deployment Script -- R0NAM1 ===")
echo("                  --- STUDENT TEMPLATE ---                   ")
echo("       --- Script 3 - Application Setup & Cleanup ---        ")

# RSAT Should be installed in Base Image!! Takes to long to download & install otherwise
#echo("")
#echo("Installing Windows RSAT AD Module to change groups!")
#Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

# Make sure we can actually use rsat activedirectory
import-module activedirectory

# If needed
#echo("")
#echo("-- Showing Applied OU's...")
#gpresult /Scope User /r

echo("")
echo("-- Installing apps specified by image...")
Set-Variable -Name "foundOU" -Value (Get-Content -Path 'C:\chosenOu.txt')

echo("")
echo("-- Installing Choclatey Packages...")
choco install firefox 7zip notepadplusplus vlc gimp inkscape -y --force
echo("-- All packages installed, assuming sucessfully since local UNC!...")

echo("")
echo("-- Downloading OSPI MS Office 2019 --")
& "\\fog\tools\installables\scripts\office2019_download.ps1"

echo("")
echo("-- Configuring OSPI MS Office 2019 --")
& "\\fog\tools\installables\scripts\office2019_config.ps1"

while ($true) {

echo("")
echo("-- Install Veyon Client?")

$answer = read-host ("-- [y/n]? > ")
if ($answer -eq 'y') { 
   choco install veyon --force -y

   echo("-- Joining to Veyon Enrolled Group...")
   $joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
    UserName = "fogjoin"
    Password = (ConvertTo-SecureString -String 'password' -AsPlainText -Force)[0]
   })

   $Groupname = "veyonEnrolled"

   $computerobj = Get-ADComputer $env:COMPUTERNAME -Credential $joinCred
   $groupobj = Get-ADGroup $Groupname -Credential $joinCred

   Add-ADGroupMember -Identity $Groupname -members $computerobj -Credential $joinCred
   break
}
elseif ($answer -eq 'n') {
   echo("")
   echo("-- Not installing Veyon Client...")
   break
}

}

echo("")
echo("-- Installing Explorer Patcher...")
echo("-- Adding Windows Defender Exceptions...")
Add-MpPreference -ExclusionPath "\\fog\tools\installables\execs\ep_setup.exe"
Add-MpPreference -ExclusionPath "C:\Program Files\ExplorerPatcher"
Add-MpPreference -ExclusionPath "$env:APPDATA\ExplorerPatcher"
Add-MpPreference -ExclusionPath "C:\Windows\dxgi.dll"
Add-MpPreference -ExclusionPath "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy"
Add-MpPreference -ExclusionPath "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy"
Start-Sleep 2
& "\\fog\tools\installables\execs\ep_setup.exe"

# FOG Client should already be installed in the base image!

echo("")
echo("-- Installing Microsoft Photos App Since SysPrep Removed It...")
winget install 9WZDNCRFJBH4 --accept-package-agreements --accept-source-agreements --silent

echo("")
echo("-- Installing FP.SetWallpaper")
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name FP.SetWallpaper -Force -Scope AllUsers -AcceptLicense

# Set Lockscreen Wallpaper
echo("")
echo("-- Installing Lock Screen")
& "\\fog\tools\installables\scripts\lockscreenWallpaper.ps1"

# Setting up Ansible Automation
# Adding to ansible group

echo("")
echo("-- Adding to AnsibleEnrolled Group")

# Get FOG credentials to add to group
# Note: These credentials have minimal access, so you can't do anything with it.

$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
    UserName = "fogjoin"
    Password = (ConvertTo-SecureString -String 'password' -AsPlainText -Force)[0]
})

$Groupname = "ansibleEnrolled"

$computerobj = Get-ADComputer $env:COMPUTERNAME -Credential $joinCred
$groupobj = Get-ADGroup $Groupname -Credential $joinCred

Add-ADGroupMember -Identity $Groupname -members $computerobj -Credential $joinCred

echo("")
echo("-- Checking what OU I'm in, then apply OU specific patches...")

Set-Variable -Name "foundOU" -Value (Get-Content -Path 'C:\chosenOu.txt')

if ($foundOU -contains "OU=libraryLab,OU=computerLabs,OU=computers,DC=domain,DC=inside") { 
  echo("")
  echo("-- Part of Library Lab! Nothing to currently do...")
  echo("-- TODO: Have Auto Printer Install... Call Script!")
}
elseif ($foundOU -contains "OU=lab1,OU=computerLabs,OU=computers,DC=domain,DC=inside") { 
  & "\\fog\tools\install_scripts\lab1.ps1"
}
elseif ($foundOU -contains "OU=lab2,OU=computerLabs,OU=computers,DC=domain,DC=inside") { 
  & "\\fog\tools\install_scripts\lab2.ps1"

}
# Catch all
elseif ($foundOU -contains "OU=computers,DC=domain,DC=inside") { 
  echo("-- Computer in base OU, nothing to do!")
}

# Running final cleanup
# Delete powershell task and tracker
echo("")
echo("-- Unregistering Deploy Task & Cleaning up!")
Unregister-ScheduledTask -TaskName deploytask -Confirm:$false
Remove-Item C:\deploy_track.txt -Force

echo("")
Read-Host ("Press any key to continue to disable Admin account and Reboot...")

# Disable built in Admin account
echo("")
echo("-- Disabling and removing built-in Administrator account")
Disable-LocalUser -Name "Administrator"

# Remove AutoLogin
echo("")
echo("-- Removing Autologin...")
$Username = 'BobbyHill'
$Pass = 'BobbyLove'
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value 0 -Type DWord 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String
Set-ItemProperty $RegistryPath 'ForceAutoLogon' -Value 0 -type DWord

echo("")
echo("-- Setting student as default login...")
& "\\fog\tools\other\setStudentLoginDefault.ps1"

echo("")
echo("-- Setting Monitor AC & DC timeout to 5 minutes...")
powercfg /x -hibernate-timeout-ac 0

powercfg /x -hibernate-timeout-dc 0

powercfg /x -disk-timeout-ac 0

powercfg /x -disk-timeout-dc 0

powercfg /x -monitor-timeout-ac 5

powercfg /x -monitor-timeout-dc 5

Powercfg /x -standby-timeout-ac 0

powercfg /x -standby-timeout-dc 0

# Force delete this file
Remove-Item -Path C:\postdeploy.ps1 -Force
Remove-Item -Path C:\deployed.txt -Force
Remove-Item -Path C:\chosenOu.txt -Force

echo(" === !Rebooting! ===")
Start-Sleep 3

# Reboot computer
Restart-Computer -Force
