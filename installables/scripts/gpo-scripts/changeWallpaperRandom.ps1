echo("")
echo("=== Changing to Random Wallpaper -- R0NAM1 ===")

# Mount Drive
net use \\fog\tools /User:none

# Choose random folder
$Folders = Get-ChildItem -Path "\\fog\tools\Wallpapers"
$chosenFolder = $Folders | Get-Random -Count 1

# Choose random file
$Files = Get-ChildItem -Path "\\fog\tools\Wallpapers\$chosenFolder"
$chosenFile = $Files | Get-Random -Count 1

$finalPath = "\\fog\tools\Wallpapers\$chosenFolder\$chosenFile"

# Grab extension
$fileExtension = [System.IO.Path]::GetExtension($finalPath)

echo("")
echo("Copying to user home...")
# Copy to user home
cp $finalPath $home\.wallpaper$fileExtension

Write-Host "Chosen file path: $finalPath"

$myPath = echo("$home\.wallpaper$fileExtension")

Write-Host "Set path: $myPath"

Get-Monitor | Set-Wallpaper -Path $myPath
