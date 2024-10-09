echo("")
echo("-- Installing Explorer Patcher...")
echo("-- Adding Windows Defender Exceptions...")
Add-MpPreference -ExclusionPath "C:\Program Files\ExplorerPatcher"
Add-MpPreference -ExclusionPath "$env:APPDATA\ExplorerPatcher"
Add-MpPreference -ExclusionPath "C:\Windows\dxgi.dll"
Add-MpPreference -ExclusionPath "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy"
Add-MpPreference -ExclusionPath "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy"
Add-MpPreference -ExclusionPath "\\fog\tools\installables\execs\ep_setup.exe"


$pkg = "\\fog\tools\installables\execs\ep_setup.exe"
& $pkg

Start-Sleep 4

echo("Applying Registry Keys...")
cp \\fog\tools\installables\scripts\explorerPatcherSettings.reg $home/explorerPatcherSettings.reg

reg import $home/explorerPatcherSettings.reg

echo("Restarting Explorer.exe...")
taskkill /f /im explorer.exe
start explorer.exe