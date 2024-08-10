echo("=== Apply ExplorerPatcher Settings -- R0NAM1 ===")

# Mount Drive
echo("Mounting FOG Tools")
net use P: \\fog\tools

echo("Applying Registry Keys...")
reg import \\fog\tools_edit\installables\scripts\explorerPatcherSettings.reg

echo("Restarting Explorer.exe...")
taskkill /f /im explorer.exe
start explorer.exe

# Unmount P
net use P: /delete

Read-Host
