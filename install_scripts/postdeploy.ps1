echo("=== Windows 11 Deployment Control Script -- R0NAM1 ===")
echo("Waiting 30 seconds to let Windows networking start...")
Start-Sleep 30

# Mount drive P
echo("Mounting \\fog\tools as anonymous user...")
net use \\fog\tools /User:none

# Check if local file exists
if (Test-Path C:\deploy_track.txt -PathType Leaf) {
	echo("Track File exists...")
}
else {
New-Item -Path "C:\deploy_track.txt" -ItemType File; 
echo "1" | Out-File -FilePath "C:\deploy_track.txt"; 
echo "File did not exist"
}

# Check value inserted into deploy_track
Set-Variable -Name "deploytrack" -Value (Get-Content -Path 'C:\deploy_track.txt')

# Depending on variable, run script 1 2 or 3
# Change which scripts need to run depending on the host
if (($deploytrack) -eq 1) {
    echo("Running Script 1");
    & "\\fog\tools\install_scripts\student_template\student_template-1.ps1"
}

elseif (($deploytrack) -eq 2) {
    echo("Running Script 2");
    & "\\fog\tools\install_scripts\student_template\student_template-2.ps1"
}

elseif (($deploytrack) -eq 3) {
    echo("Running Script 3");
    & "\\fog\tools\install_scripts\student_template\student_template-3.ps1"
}
