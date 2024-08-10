echo("=== Windows Script -- R0NAM1 ===")
echo("--- Log Off Script - Setting domain\Student as default ---")

# Set registry path (HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI)

# Set LastLoggedOnDisplayName to 'Student'
echo("Setting LastLoggedOnDisplayName to 'Student'")
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnDisplayName /f
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnDisplayName /d Student /f

# Set LastLoggedOnSAMUser to 'DOMAIN\student'
echo("Setting LastLoggedOnSAMUser to 'DOMAIN\student'")
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnSAMUser /f
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnSAMUser /d DOMAIN\student /f

# Set LastLoggedOnUser to 'DOMAIN\student'
echo("Setting LastLoggedOnUser to 'DOMAIN\student'")
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnUser /f
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnUser /d DOMAIN\student /f

# Set LastLoggedOnUserSID to 'S-1-5-21-715914107-1201407081-4266531891-1113'
echo("Setting LastLoggedOnUserSID to 'S-1-5-21-715914107-1201407081-4266531891-1113'")
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnUserSID /f
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI /v LastLoggedOnUserSID /d S-1-5-21-715914107-1201407081-4266531891-1113 /f
