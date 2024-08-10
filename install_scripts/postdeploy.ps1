echo("=== Windows 11 Deployment Control Script -- R0NAM1 ===")

# Mount drive P
echo("Mounting \\fog\tools as P:\")
net use P: \\fog\tools

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
if (($deploytrack) -eq 1) {
    echo("Running Script 1");
    & "P:\install_scripts\student_template\student_template-1.ps1"
}

elseif (($deploytrack) -eq 2) {
    echo("Running Script 2");
    & "P:\install_scripts\student_template\student_template-2.ps1"
}

elseif (($deploytrack) -eq 3) {
    echo("Running Script 3");
    & "P:\install_scripts\student_template\student_template-3.ps1"
}
