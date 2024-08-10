echo("=== Changing to Random Wallpaper -- R0NAM1 ===")

# Mount Drive
net use P: \\fog\tools

# Choose random folder
$Folders = Get-ChildItem -Path P:\Wallpapers
$chosenFolder = $Folders | Get-Random -Count 1

# Choose random file
$Files = Get-ChildItem -Path P:\Wallpapers\$chosenFolder
$chosenFile = $Files | Get-Random -Count 1

$finalPath = "P:\Wallpapers\$chosenFolder\$chosenFile"

# Grab extension
$fileExtension = [System.IO.Path]::GetExtension($finalPath)

# Copy to user home
cp $finalPath ~/.wallpaper$fileExtension

Write-Host "Chosen file path: $finalPath"

Get-Monitor | Set-Wallpaper -Path ~/.wallpaper$fileExtension

# Unmount P
net use P: /delete

#Read-Host
