echo("=== Project STEM shortcut install -- R0NAM1 ===")

# Mount tools
net use \\fog\tools /User:none

# Move
echo("=== Putting Shortcut into Public Desktop ===")
cp -r \\fog\tools\installables\.projectstem.ico "C:\Users\Public\."

$shell = New-Object -ComObject WScript.Shell
$Location = "C:\Users\Public\Desktop\."
$shortcut = $shell.CreateShortcut("$Location\Project STEM.lnk")
$shortcut.TargetPath = 'https://projectstem.org/users/sign_in'
$shortcut.IconLocation = "C:\Users\Public\.projectstem.ico"
$shortcut.Save()