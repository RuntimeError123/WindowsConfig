
function SetAuOptions
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(2,5)]
        [int]$AuOptions
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    New-ItemProperty -Path $RegKey -PropertyType DWord -Name AuOptions -Value $AuOptions -Force | Out-Null
}

function SetScheduledInstallDay
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,7)]
        [int]$ScheduledInstallDay
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    New-ItemProperty -Path $RegKey -PropertyType DWord -Name ScheduledInstallDay -Value $ScheduledInstallDay -Force | Out-Null
}

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

$AuOptions = 4 #2 = Notify before download, 3 = Automatically download and notify of installation, 4 = Automatic download and scheduled installation, 5 = Automatic Updates is required, but end users can configure it.
$ScheduledInstallDay = 0 #Scheduled install day (0 = every day, 1 = Sunday, 2 = Monday, etc.)
$ScheduledInstallTime = 3 #Install updates time

WriteLog -Message "Configuring Windows Update with AuOptions: $AuOptions, ScheduledInstallDay: $ScheduledInstallDay, ScheduledInstallTime: $ScheduledInstallTime" -Severity Information

SetAuOptions -AuOptions $AuOptions
SetScheduledInstallDay -ScheduledInstallDay $ScheduledInstallDay
SetScheduledInstallTime -ScheduledInstallTime $ScheduledInstallTime

#Restart Windows Update service
WriteLog -Message "Restarting Windows Update service" -Severity Information
Get-Service -Name wuauserv | Restart-Service

WriteLog -Message "Scanning for updates" -Severity Information
Import-Module -Name WindowsUpdateProvider
$Updates = Start-WUScan -SearchCriteria "Type='Software' AND IsInstalled=0 AND IsHidden=0 AND IsAssigned=1"
if ($Updates.Count -gt 0)
{
    WriteLog -Message "Installing $($Updates.Count) updates. This may take a while" -Severity Information
    $RebootRequired = Install-WUUpdates -Updates $Updates

    if ($RebootRequired -eq $true)
    {
        WriteLog -Message "A reboot is required" -Severity Warning
    }
    else
    {
        WriteLog -Message "No reboot is required" -Severity Information
    }
}
else
{
    WriteLog -Message "No updates found" -Severity Information    
}