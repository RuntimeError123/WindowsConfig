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

    WriteLog -Message "Current: DHCP: $CurrentDHCPEnabled, IPAddress: $CurrentIPAddress, PrefixLength: $CurrentPrefixLength, DefaultGateway: $CurrentDefaultGateway, PrimaryDNS: $CurrentPrimaryDNS" -Severity Information
    WriteLog -Message "New: DHCP: $DHCPEnable, IPAddress: $IPAddress, PrefixLength: $PrefixLength, DefaultGateway: $DefaultGateway, PrimaryDNS: $PrimaryDNS" -Severity Information

    if ($DHCPEnable -eq $false)
    {
        if ($CurrentDHCPEnabled -eq $true)
        {
            #Disable DHCP
            WriteLog -Message "Disabling DHCP" -Severity Information
            $FirstNetworkAdapter | Set-NetIPInterface -Dhcp Disabled
            #Set static IP 
            WriteLog -Message "Configuring static IP" -Severity Information
            Start-Sleep -Seconds 5
            $FirstNetworkAdapter | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | Get-NetIPAddress | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway | Out-Null
            #Set primary DNS
            WriteLog -Message "Configuring primary DNS server" -Severity Information
            $FirstNetworkAdapter | Set-DnsClientServerAddress -ServerAddresses $PrimaryDNS
        }
    }
    if ($DHCPEnable -eq $true)
    {
        if ($CurrentDHCPEnabled -eq $false)
        {
            WriteLog -Message "Enabling DHCP" -Severity Information
            $FirstNetworkAdapter | Get-NetIPAddress | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue
            $FirstNetworkAdapter | Set-NetIPInterface -Dhcp Enabled
            $FirstNetworkAdapter | Set-DnsClientServerAddress -ResetServerAddresses
        }
    }
}

$CurrentComputerName = Get-ItemPropertyValue HKLM:\SYSTEM\ControlSet001\Control\ComputerName\ComputerName -Name ComputerName
$NetworkConfigFile = Join-Path -Path ($PSScriptRoot | Split-Path -Parent) -ChildPath "Config\Network.csv"
$NetworkConfig = Import-Csv -Path $NetworkConfigFile
$ApplicableNetworkConfig = $NetworkConfig | Where-Object -Property ComputerName -eq $CurrentComputerName

if ($ApplicableNetworkConfig)
{
    SetNetworkConfig -DHCPEnable ([system.convert]::ToBoolean($ApplicableNetworkConfig.DHCPEnable)) -IPAddress $ApplicableNetworkConfig.IPAddress -PrefixLength $ApplicableNetworkConfig.PrefixLength -DefaultGateway $ApplicableNetworkConfig.DefaultGateway -PrimaryDNS $ApplicableNetworkConfig.PrimaryDNS
}