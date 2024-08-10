echo("=== Lightspeed Relay Certificate Renewal -- R0NAM1 ===")
echo("Attemping to renew certificate for Lightspeed Man-In-The-Middle Traffic Inspection")

echo("Creating New Certificate Using MakeCa.exe...")
"c:\Program Files\Lightspeed Systems\Smart Agent\makeca.exe" -dir %temp%\

echo("Moving Generated Certificate to Lightspeed Filter Installation Directory...")
move /y %temp%*.pem "c:\Program Files\Lightspeed Systems\Smart Agent"

echo("Registering certificate to the ROOT STORE")
certutil.exe -addstore root "c:\Program Files\Lightspeed Systems\Smart Agent\ca.pem"

echo("Stopping lssascv...")
net stop lssasvc

echo("Starting lssascv...")
net start lssasvc

echo("Certificate is regenerated and computer should have another year of Big Brother!")

Start-Sleep -Seconds 5.0
