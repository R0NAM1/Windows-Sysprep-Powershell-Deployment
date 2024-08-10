echo("=== Windows 11 Deployment Script -- R0NAM1 ===")
echo("--- Script 3 - Application Setup & Cleanup ---")

# Create task scripts to run automatically based on events:

echo("=== Verifying tasks to run on domain\Student logout ===")

echo("-- Showing Applied OU's --")

gpresult /Scope User /r

Read-Host ("Press enter to continue...")

# Now we install apps that are needed, all below:
echo("=== Installing apps specified by image ===")

echo("-- Installing Chocolatey Package Manager --")
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

echo("-- Installing Choclatey Packages... ---")
choco install googlechrome zoom notepadplusplus.install 7zip.install vlc windirstat gimp inkscape

# FOG Client should already be installed in the base image!

# Install MSI's
$pkg = ""
Start-Process msiexec "/a $pkg /qn";

# Now we install printers that are needed, all below:
echo("=== Installing printers specified by image ===")
echo("(Currently no printers to install...)")

echo("=== Installing PSModules specified by image ===")
# Installing Nuget
echo("=== Installing NuGet ===")
Install-PackageProvider -Name NuGet -Force -Verbose -Scope AllUsers -ForceBootstrap

echo("=== Installing FP.SetWallpaper ===")
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name FP.SetWallpaper -Force -Verbose -Scope AllUsers

# Set Lockscreen Wallpaper
echo("=== Installing Lock Screen Wallpaper ===")
& "P:\installables\scripts\lockscreenWallpaper.ps1"

# Setting up Ansible Automation

& "\\fog\tools_edit\installables\scripts\setup-ansible-winrm-listener.ps1"

# Adding to ansible group

$groupParams = @{
    Identity = 'CN=ansibleEnrolled,OU=computers,DC=domain,DC=inside'
    Server = 'domain.inside'
}

$Group = Get-ADGroup @groupParams
Add-ADGroupMember -Identity $Group

# Running final cleanup

# Delete powershell task and tracker
echo("Unregistering Deploy Task")
Unregister-ScheduledTask -TaskName deploytask -Confirm:$false
Remove-Item C:\deploy_track.txt -Force

# Disable built in Admin account
echo("=== Disabling and removing built-in Administrator account ===")
Disable-LocalUser -Name "Administrator"

# Remove AutoLogin
$Username = 'temp'
$Pass = 'BobbyLove'
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "0" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String 
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String

# Remove account path
Remove-Item C:\Users\Administrator -Force -Recursive

# Force delete this file
Remove-Item -Path C:\postdeploy.ps1 -Force

Read-Host

# Reboot computer
Restart-Computer -Force
