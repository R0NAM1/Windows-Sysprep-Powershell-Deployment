echo("=== Windows 11 Deployment Script -- R0NAM1 ===")
echo("--- Script 2 - Domain Setup & Config ---")

# Set default OU path
$ouPath = "OU=computers,DC=domain,DC=inside"

# Loop forever to get proper user input
while ($true) {

# LAB SETUP
echo("")
echo(" | -- If this is a lab computer, specify so below and stuff will autoinstall, otherwise move on and will go into computers...")
echo("")
echo(" | 1. Library Lab - Room 100 - Librarian")
echo(" | 2. Lab 1 - Room 101 - John Doe")
echo(" | 3. Lab 2 - Room 102 - Jane Doe")
echo(" | 4. Tech Testing")
echo(" | e. Exit")
echo("------------------------")
echo("")
$answer = read-host (" | > ")
echo("")

if ($answer -eq '1') {
echo("-- Joining to Library Lab! (OU=libraryLab,OU=computerLabs,OU=computers,DC=domain,DC=inside)")
$ouPath = "OU=libraryLab,OU=computerLabs,OU=computers,DC=domain,DC=inside"
break
}

elseif ($answer -eq '2') {
echo("-- Joining to Lab 1! (OU=lab1,OU=computerLabs,OU=computers,DC=domain,DC=inside)")
$ouPath = "OU=lab1,OU=computerLabs,OU=computers,DC=domain,DC=inside"
break
}

elseif ($answer -eq '3') {
echo("-- Joining to Lab 2! (OU=lab2,OU=computerLabs,OU=computers,DC=domain,DC=inside)")
$ouPath = "OU=lab2,OU=computerLabs,OU=computers,DC=domain,DC=inside"
break
}

elseif ($answer -eq '4') {
echo("-- Joining to Tech Testing! (OU=techTesting,OU=computerLabs,OU=computers,DC=domain,DC=inside)")
$ouPath = "OU=techTesting,OU=computerLabs,OU=computers,DC=domain,DC=inside"
break
}

elseif  ($answer -eq 'e') {
   echo("-- Exiting with default ou (OU=computers,DC=domain,DC=inside)...")
   break
}
}

echo("")
echo("-- Joining " + $env:computername + " to domain.inside domain...")
echo("- Welcome to my domain, insect. - SHODAN")

$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
    UserName = "fogjoin"
    Password = (ConvertTo-SecureString -String 'password' -AsPlainText -Force)[0]
})

# Join specific OU based on image
Add-Computer -DomainName domain.inside -OUPath $ouPath -Credential $joinCred

echo("-- Computer sucessfully joined to $ouPath")
echo("-- Writing C:\chosenOu.txt")
echo $ouPath | Out-File -FilePath "C:\chosenOu.txt"; 


# Set deploy_track to 3
echo "3" | Out-File -FilePath "C:\deploy_track.txt"
echo("")
echo("-- Wrote track file to 3...")

echo("")
echo("")
Read-Host (" === !Ready to reboot! ===")
# Reboot computer
Restart-Computer -Force
