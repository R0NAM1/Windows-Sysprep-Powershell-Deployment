echo("")
echo("=== Apply ExplorerPatcher Settings -- R0NAM1 ===")

# Mount Drive
echo("Mounting FOG Tools")
net use \\fog\tools /User:none

echo("Applying Registry Keys...")
cp \\fog\tools\installables\scripts\explorerPatcherSettings.reg $home/explorerPatcherSettings.reg

reg import $home/explorerPatcherSettings.reg

echo("Restarting Explorer.exe...")
taskkill /f /im explorer.exe
start explorer.exe