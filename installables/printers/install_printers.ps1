while ($true) {

echo("")
echo("=== Printer Deployment -- R0NAM1 ===")
echo(" Press the number associated with your printer and vamoos!")
echo("----------------------------------------------------------")
echo("")

# Attempt to mount
net use \\fog\tools /User:none

echo("1. Office - Brother HL-4150CDN - 10.10.10.10")
echo("2. Office - Brother HL-4150CDN - 10.10.10.10")
echo("e. Exit Printer Installer")
echo("")



$answer = read-host (" Make Your Choice: ")

if ($answer -eq '1') { 
   $printerName = "Office"


   # Register printer driver 
   $driverPath = "\\fog\tools\installables\printers\brother_hl4150cdn\BROCHB0A.INF"
   pnputil /add-driver $driverPath
   
   #Brother HL-4150CDN series
   Add-PrinterDriver -Name "Brother HL-4150CDN series" -InfPath "C:\Windows\System32\DriverStore\FileRepository\brochb0a.inf_amd64_a28c08a21a7185e9\BROCHB0A.INF"

   echo("")
   echo("== Showing current installed printer drivers... ==")
   Get-PrinterDriver

   # Add printer port to connect to 
   Add-PrinterPort -Name "IP_10.10.10.10" -PrinterHostAddress "10.10.10.10"
   
   # Sleep to let it register
   Start-Sleep 10 

   Add-Printer -Name $printerName -ShareName "Printer Share namer"  -PortName IP_10.10.10.10 -DriverName "Brother HL-4150CDN series"
}

elseif ($answer -eq '2') { 
   $printerName = "Office"


   # Register printer driver 
   $driverPath = "\\fog\tools\installables\printers\brother_hl4150cdn\BROCHB0A.INF"
   pnputil /add-driver $driverPath
   
   #Brother HL-4150CDN series
   Add-PrinterDriver -Name "Brother HL-4150CDN series" -InfPath "C:\Windows\System32\DriverStore\FileRepository\brochb0a.inf_amd64_a28c08a21a7185e9\BROCHB0A.INF"

   echo("")
   echo("== Showing current installed printer drivers... ==")
   Get-PrinterDriver

   # Add printer port to connect to 
   Add-PrinterPort -Name "IP_10.10.10.10" -PrinterHostAddress "10.10.10.10"
   
   # Sleep to let it register
   Start-Sleep 10 

   Add-Printer -Name $printerName -ShareName "Printer Share namer"  -PortName IP_10.10.10.10 -DriverName "Brother HL-4150CDN series"
}

elseif  ($answer -eq 'e') {
   echo("Exiting Printer Install Script...")
   break
}

else {
}

echo("Setting last installed printer as default ($printerName)...")
$Printer = Get-CimInstance -Class Win32_Printer -Filter "Name='$printerName'"
Invoke-CimMethod -InputObject $Printer -MethodName SetDefaultPrinter 
}