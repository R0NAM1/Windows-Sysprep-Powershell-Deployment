echo("=== Typing.com shortcut install -- R0NAM1 ===")

# Mount tools
net use P: \\fog\tools

# Move
echo("=== Putting Shortcut into Public Desktop ===")
cp -r P:\installables\.typing.ico "C:\Users\Public\."

#cp -r P:\installables\Typing.com.url "C:\Users\Public\Desktop\."

$shell = New-Object -ComObject WScript.Shell
$Location = "C:\Users\Public\Desktop\."
$shortcut = $shell.CreateShortcut("$Location\Typing.com.lnk")
$shortcut.TargetPath = 'https://www.typing.com/student/login'
$shortcut.IconLocation = "C:\Users\Public\.typing.ico"
$shortcut.Save()

# Unmount tools
net use P: /delete

Read-Host