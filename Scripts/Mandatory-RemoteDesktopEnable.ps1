function EnableRemoteDesktop
{
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -value 0 -Force | Out-Null
}

function AllowOnlyNLAForRDPConnections
{
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -value 1 -Force | Out-Null
}

#Enable remote desktop
WriteLog -Message "Enabling Remote Desktop" -Severity Information
EnableRemoteDesktop

#Allow only NLA connections
WriteLog -Message "Allowing RDP only using NLA" -Severity Information
AllowOnlyNLAForRDPConnections

#Allow through firewall
WriteLog -Message "Adding firewall rule to allow RDP" -Severity Information
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"