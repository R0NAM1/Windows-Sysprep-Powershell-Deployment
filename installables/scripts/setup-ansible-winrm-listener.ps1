echo("=== Setting Up Ansible Automation -- R0NAM1 ===")

# Mount Drive
net use P: \\fog\tools

echo("Creating WinRM Listener...")
winrm quickconfig

echo("Done!")

# Unmount P
net use P: /delete

#Read-Host
