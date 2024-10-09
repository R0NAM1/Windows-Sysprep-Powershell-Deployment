# DO WITH GPO!!
echo("=== Veyon Docs shortcut install -- R0NAM1 ===")

# Mount tools
net use \\fog\tools /User:none

# Move
echo("=== Putting Shortcut into Public Desktop ===")
cp -r P:\installables\.veyon.ico "C:\Users\Public\."

$shell = New-Object -ComObject WScript.Shell
$Location = "C:\Users\Public\Desktop\."
$shortcut = $shell.CreateShortcut("$Location\Veyon-Docs.com.lnk")
$shortcut.TargetPath = 'https://docs.veyon.io/en/latest/user/index.html'
$shortcut.IconLocation = "C:\Users\Public\.veyon.ico"
$shortcut.Save()