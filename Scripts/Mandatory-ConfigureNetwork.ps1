function SetNetworkConfig
{   
    [cmdletbinding()]
    Param(
        [bool]$DHCPEnable,
        $IPAddress,
        $PrefixLength,
        $DefaultGateway,
        $PrimaryDNS
    )
    $FirstNetworkAdapter = Get-NetAdapter | Select-Object -First 1

    #Get current values
    $CurrentDHCPEnabled = if (( ($FirstNetworkAdapter | Get-NetIPAddress -AddressFamily IPv4).PrefixOrigin ) -eq "DHCP") {$true} else {$false}
    $CurrentIPAddress = ($FirstNetworkAdapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
    $CurrentPrefixLength = ($FirstNetworkAdapter | Get-NetIPAddress -AddressFamily IPv4).PrefixLength
    $CurrentDefaultGateway = ($FirstNetworkAdapter | Get-NetRoute -RouteMetric 0 -ErrorAction SilentlyContinue).NextHop
    $CurrentPrimaryDNS = ($FirstNetworkAdapter | Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -First 1

    Write-Verbose -Message "Current: DHCP: $CurrentDHCPEnabled, IPAddress: $CurrentIPAddress, PrefixLength: $CurrentPrefixLength, DefaultGateway: $CurrentDefaultGateway, PrimaryDNS: $CurrentPrimaryDNS"
    Write-Verbose -Message "New: DHCP: $DHCPEnable, IPAddress: $IPAddress, PrefixLength: $PrefixLength, DefaultGateway: $DefaultGateway, PrimaryDNS: $PrimaryDNS"

    if ($DHCPEnable -eq $false)
    {
        if ($CurrentDHCPEnabled -eq $true)
        {
            #Disable DHCP
            $FirstNetworkAdapter | Set-NetIPInterface -Dhcp Disabled
            #Set static IP 
            $FirstNetworkAdapter | Get-NetIPAddress | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway | Out-Null
            #Set primary DNS
            $FirstNetworkAdapter | Set-DnsClientServerAddress -ServerAddresses $PrimaryDNS
        }
    }
    if ($DHCPEnable -eq $true)
    {
        if ($CurrentDHCPEnabled -eq $false)
        {
            $FirstNetworkAdapter | Get-NetIPAddress | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | Set-NetIPInterface -Dhcp Enabled
            $FirstNetworkAdapter | Set-DnsClientServerAddress -ResetServerAddresses
        }
    }
}

$NetworkConfigFile = Join-Path -Path ($PSScriptRoot | Split-Path -Parent) -ChildPath "Config\Network.csv"
$NetworkConfig = Import-csv -Path $NetworkConfigFile
$ApplicableNetworkConfig = $NetworkConfig | Where-Object -Property ComputerName -eq $env:COMPUTERNAME

SetNetworkConfig -DHCPEnable ([system.convert]::ToBoolean($ApplicableNetworkConfig.DHCPEnable)) -IPAddress $ApplicableNetworkConfig.IPAddress -PrefixLength $ApplicableNetworkConfig.PrefixLength -DefaultGateway $ApplicableNetworkConfig.DefaultGateway -PrimaryDNS $ApplicableNetworkConfig.PrimaryDNS