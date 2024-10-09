# DO WITH GPO!!
echo("=== Typing.com shortcut install -- R0NAM1 ===")

# Mount tools
net use \\fog\tools /User:none

# Move
echo("=== Putting Shortcut into Public Desktop ===")
cp -r \\fog\tools\installables\.typing.ico "C:\Users\Public\."

$shell = New-Object -ComObject WScript.Shell
$Location = "C:\Users\Public\Desktop\."
$shortcut = $shell.CreateShortcut("$Location\Typing.com.lnk")
$shortcut.TargetPath = 'https://www.typing.com/student/login'
$shortcut.IconLocation = "C:\Users\Public\.typing.ico"
$shortcut.Save()