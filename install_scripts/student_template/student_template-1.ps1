echo("=== Windows 11 Deployment Script -- R0NAM1 ===")
echo ("--- Script 1 - Local Setup & Config ---")

# Mount drive P
echo("Mounting \\fog\tools as P:\")
net use P: \\fog\tools
echo("Mounted!")

echo("-- Creating Task to run C:/postdeploy.ps1 on boot --")

$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "C:\postdeploy.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = "./Administrator"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
#-Principal $principal

Register-ScheduledTask T1 -InputObject $task -TaskName 'deploytask'

echo("-- Task Created --")
echo("-- Attempting to generate Hostname based on System Manufacturer Details --")
echo("")

echo("=============================================================================")
echo("")

$Manufacturer = (Get-WmiObject -class win32_bios).Manufacturer
echo(" | Manufacturer: " + $Manufacturer + "|")

$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber
$s = #SerialNumber
echo(" | Serial # ($s): " + $SerialNumber + "|")
echo("")

$genHostname = ($SerialNumber + "-" + $Manufacturer)

echo("")
echo("")
echo("Generated [" + $genHostname + "], press Enter to accept")
$desiredHostname = Read-Host ("or type in desired hostname.")


# Now depending on $desiredHostname we do the following:
# Empty -> continue with genHostname
# Not empty -> continue with desiredHostname

if ((Get-Variable -Name "desiredHostname") -eq "") {
    echo("Using " + $genHostname);
    Rename-Computer -NewName ($genHostname)
}

else {
    echo("Using " + $desiredHostname);
    Rename-Computer -NewName ($desiredHostname)
}

# Set deploy_track to 2
echo "2" | Out-File -FilePath "C:\deploy_track.txt"
echo("Wrote track file to 2.")

# Set local admin auto login
$Username = '.\Administrator'
$Pass = 'password'
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String 
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String
 
# Reboot computer with autologin
Restart-Computer -Force