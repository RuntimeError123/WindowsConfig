function SetTelemetry
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,4)]
        [int]$TelemetryLevel
    )

    $RegKey = @("HKLM:\Software\Policies\Microsoft\Windows\DataCollection","HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection")
    
    $RegKey | ForEach-Object -Process {Set-ItemProperty -Path $_ -Name AllowTelemetry -Value $TelemetryLevel}
}

$TelemetryLevel = 1 # = Basic

WriteLog -Message "Configuring Telemetry to level $TelemetryLevel" -Severity Information
SetTelemetry -TelemetryLevel $TelemetryLevel