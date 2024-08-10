echo("=== Project STEM shortcut install -- R0NAM1 ===")

# Mount tools
net use P: \\fog\tools

# Move
echo("=== Putting Shortcut into Public Desktop ===")
cp -r P:\installables\.projectstem.ico "C:\Users\Public\."

#cp -r "P:\installables\Project STEM.url" "C:\Users\Public\Desktop\."

$shell = New-Object -ComObject WScript.Shell
$Location = "C:\Users\Public\Desktop\."
$shortcut = $shell.CreateShortcut("$Location\Project STEM.lnk")
$shortcut.TargetPath = 'https://projectstem.org/users/sign_in'
$shortcut.IconLocation = "C:\Users\Public\.projectstem.ico"
$shortcut.Save()

# Unmount tools
net use P: /delete

Read-Host