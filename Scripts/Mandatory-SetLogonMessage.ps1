$LogonMessageTitle = "* * * * * * * * WARNING * * * * * * * *"
$LogonMessage = "Welcome to L3N.nl. All activities on this system are logged. Disconnect IMMEDIATELY if you are not an authorized user!"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticecaption" -Value $LogonMessageTitle
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticetext" -Value $LogonMessage