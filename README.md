Need more in depth post deployment configuration for your Windows 11 terminals?

Well if you create your own SysPrep images you are in luck! In combination with the FOG project, it's easy to run Powershell scripts to setup
your individual terminals post SysPrep, here is a quick tutorial.

- How To -

1. Create two SMB shares, one that is public and read only, another that is user authenticated and editable. Have both these shares point to the same directory.

2. Git clone this repo into that directory

3. Generate a unattended.xml file from https://schneegans.de/windows/unattend-generator/. Make sure to fill in under Run custom scripts -> Scripts to run when the first user logs on -> 1: C:\postDeploy.ps1 as a .ps1 file. Also modify:
User accounts: Admin password Administrators
Activate built-in account "Administrator" and logon to this account
set password to: password

Enable long paths

Allow execution of PowerShell script files

Disable app suggestions

Disable widgets


4. Save that file into \\mount\share\other\. and modify:


<File path="C:\Windows\Setup\Scripts\unattend-01.ps1"> C:\postDeploy.ps1</File>

To

<File path="C:\postDeploy.ps1"></File>

This ensures that the script runs in an actual user interactable window so we can just immediently start configuring the machine.

5. Modify scripts to reflect your environment (Just comb through them all honestly, pick n pull)

6. Then you can either run postDeploy yourself of include it in the above SysPrep unattend.