echo("=== Changing Lockscreen Wallpaper -- R0NAM1 ===")

# Mount Drive
net use P: \\fog\tools

# Copy to root
echo("Copying lockscreen to C:\lockscreen.jpg")
cp P:\installables\scripts\lockscreen.jpg C:\lockscreen.jpg


echo("Setting Lockscreen")
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

if (!(Test-Path -Path $Key)) {

   New-Item -Path $Key -Force | Out-Null

}

Set-ItemProperty -Path $Key -Name LockScreenImagePath -value "C:\lockscreen.jpg"
