function SetScheduledInstallTime
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,23)]
        [int]$ScheduledInstallTime
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    New-ItemProperty -Path $RegKey -PropertyType DWord -Name ScheduledInstallTime -Value $ScheduledInstallTime -Force | Out-Null
}

$ScheduledInstallTime = 4 #Install updates time

WriteLog -Message "Configuring Windows Update with ScheduledInstallTime: $ScheduledInstallTime" -Severity Information
SetScheduledInstallTime -ScheduledInstallTime $ScheduledInstallTime

#Restart Windows Update service
WriteLog -Message "Restarting Windows Update service" -Severity Information
Get-Service -Name wuauserv | Restart-Service