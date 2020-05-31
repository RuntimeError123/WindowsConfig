function EnableRemoteDesktop
{
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -value 0 -Force | Out-Null
}

function AllowOnlyNLAForRDPConnections
{
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -value 1 -Force | Out-Null
}

#Enable remote desktop
EnableRemoteDesktop

#Allow only NLA connections
AllowOnlyNLAForRDPConnections

#Allow through firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"