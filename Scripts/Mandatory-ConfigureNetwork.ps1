function SetNetworkConfig
{
    Param(
        $IPAddress,
        $PrefixLength,
        $DefaultGateway,
        $PrimaryDNS
    )

    $FirstNetworkAdapter = Get-NetAdapter | Select-Object -First 1

    #Get current values
    $CurrentDHCPEnabled = switch ( ($FirstNetworkAdapter | Get-NetIPAddress -AddressFamily IPv4).PrefixOrigin ) { "DHCP" { $true } "Manual" { $false } } #true for DHCP on, false for DHCP off
    $CurrentIPAddress = ($FirstNetworkAdapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
    $CurrentPrefixLength = ($FirstNetworkAdapter | Get-NetIPAddress -AddressFamily IPv4).PrefixLength
    $CurrentDefaultGateway = ($FirstNetworkAdapter | Get-NetRoute -RouteMetric 0).NextHop
    $CurrentPrimaryDNS = ($FirstNetworkAdapter | Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Select-Object -First 1

    #Set static IP 
    if ($IPAddress

}

$NetworkConfigFile = Join-Path -Path ($PSScriptRoot | Split-Path -Parent) -ChildPath "Config\Network.csv"
$NetworkConfig = Import-csv -Path $NetworkConfigFile
$ApplicableNetworkConfig = $NetworkConfig | Where-Object -Property ComputerName -eq $env:COMPUTERNAME

SetNetworkConfig -IPAddress $ApplicableNetworkConfig.IPAddress --PrefixLength $ApplicableNetworkConfig.PrefixLength -DefaultGateway $ApplicableNetworkConfig.DefaultGateway -PrimaryDNS $ApplicableNetworkConfig