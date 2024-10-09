echo("")
echo("=== Changing Lockscreen Wallpaper -- R0NAM1 ===")

# Copy to root
echo("Copying lockscreen to C:\lockscreen.jpg")
cp \\fog\tools\installables\scripts\lockscreen.jpg C:\lockscreen.jpg


echo("Setting Lockscreen")
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

if (!(Test-Path -Path $Key)) {

   New-Item -Path $Key -Force | Out-Null

}

Set-ItemProperty -Path $Key -Name LockScreenImagePath -value "C:\lockscreen.jpg"