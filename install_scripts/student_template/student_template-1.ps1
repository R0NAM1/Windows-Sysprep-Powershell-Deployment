echo("For some reason CMD has issues with the Unattended.xml first login scripts.")
Read-Host("Press enter to run initial checks...")


echo("")
echo("-- Enabling Auto Login for Local Admin...")
$Username = '.\Administrator'
$Pass = 'password'
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value 1 -Type DWord
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String
Set-ItemProperty $RegistryPath 'ForceAutoLogon' -Value 1 -type DWord

echo("")
echo("-- Zeroing Power Config...")
powercfg /x -hibernate-timeout-ac 0

powercfg /x -hibernate-timeout-dc 0

powercfg /x -disk-timeout-ac 0

powercfg /x -disk-timeout-dc 0

powercfg /x -monitor-timeout-ac 0

powercfg /x -monitor-timeout-dc 0

Powercfg /x -standby-timeout-ac 0

powercfg /x -standby-timeout-dc 0

echo("-- Disabling Dynamic Locking...")
Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" 'EnableGoodbye' -Value 00000000 -Type DWord

Start-Sleep 5

echo("")
echo("-- Checking if predeploy task is created...")

# Check value inserted into deploy_track
Set-Variable -Name "deployed" -Value (Get-Content -Path 'C:\deployed.txt')

# Depending on variable, run script 1 2 or 3
if (($deployed) -eq 1) {
echo("Exists, continuing script...")
}
else {
echo("")
echo("-- Creating Task to run C:/postdeploy.ps1 on boot...")
$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "C:\postdeploy.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = "./Administrator"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
#-Principal $principal

Register-ScheduledTask T1 -InputObject $task -TaskName 'deploytask'

echo "1" | Out-File -FilePath "C:\deployed.txt";

echo("")
echo("-- Task Created, rebooting in 10 seconds!")

Start-Sleep 10
Restart-Computer -Force
}

clear
Start-Sleep 2

echo("")
echo("==============================================")
echo("=== Windows 11 Deployment Script -- R0NAM1 ===")
echo("          --- STUDENT TEMPLATE ---                   ")
echo ("   --- Script 1 - Local Setup & Config ---          ")

echo("")
echo("-- Attempting to generate Hostname based on System Manufacturer Details...")
echo("")

echo("=============================================================================")
echo("")

$Manufacturer = (Get-WmiObject -class win32_bios).Manufacturer

# ALIAS's
if ($Manufacturer -eq 'Dell Inc.') { 
   $Manufacturer = "Dell"
}
elseif ($Manufacturer -eq 'Example Long Name') { 
   $Manufacturer = "ShortName"
}

echo(" | Manufacturer: " + $Manufacturer + " |")

$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber

echo(" | Serial: " + $SerialNumber + " |")
echo("")

$genHostname = ($Manufacturer + "-" + $SerialNumber)

echo(" | Generated [ " + $genHostname + " ], press Enter to accept")
$desiredHostname = Read-Host (" | Or type in desired hostname: ")

# Now depending on $desiredHostname we do the following:
# Empty -> continue with genHostname
# Not empty -> continue with desiredHostname

if (!$desiredHostname) {
    echo("")
    echo("-- Using " + $genHostname);
    Rename-Computer -NewName ($genHostname)
}

else {
    echo("")
    echo("-- Using " + $desiredHostname);
    Rename-Computer -NewName ($desiredHostname)
}

echo("")
echo("-- Installing Chocolatey Package Manager...")
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

echo("")
echo("-- Switching to local UNC repo...")
choco source add --name="localrepo" --source="\\fog\tools\choco_repo"
choco source remove -n=chocolatey

echo("")
echo("-- Installing PowershellCore with Choclity...")
choco install powershell-core -y --force

echo("")
echo("-- Installing NuGet & PowershellGet...")
Install-PackageProvider -Name NuGet -Force -Scope AllUsers -ForceBootstrap
Install-Module PowerShellGet -AllowClobber -Force -Scope AllUsers

echo("")
echo("-- Running SFC /scannow...")
sfc /scannow

echo("")
echo("-- Removing temp account just in case...")
Remove-LocalUser -Name "temp"

# Set deploy_track to 2
echo "2" | Out-File -FilePath "C:\deploy_track.txt"
echo("-- Wrote track file to 2...")

echo("")
echo("")
Read-Host (" === !Ready to reboot! ===")
 
# Reboot computer with autologin
Restart-Computer -Force