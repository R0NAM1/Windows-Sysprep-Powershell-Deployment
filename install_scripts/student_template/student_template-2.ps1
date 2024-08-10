echo("=== Windows 11 Deployment Script -- R0NAM1 ===")
echo("--- Script 2 - Domain Setup & Config ---")

echo("-- Joining " + $env:computername + " to domain.inside --")

$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
    UserName = "fogjoin"
    Password = (ConvertTo-SecureString -String 'password' -AsPlainText -Force)[0]
})

# Join specific OU based on image
Add-Computer -DomainName domain.inside -OUPath "OU=techTesting,OU=computers,DC=domain,DC=inside" -Credential $joinCred

echo("-- Computer sucessfully joined to /computers/techTesting --")

# Set deploy_track to 3
echo "3" | Out-File -FilePath "C:\deploy_track.txt"
echo("Wrote track file to 3")

# Reboot computer
Restart-Computer -Force
