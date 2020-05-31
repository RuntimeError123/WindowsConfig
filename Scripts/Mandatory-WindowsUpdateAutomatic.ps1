function SetAllowMUUpdateService
{
    Param(
        [Parameter(Mandatory=$true)]
        [bool]$AllowMUUpdateService
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    switch ($AllowMUUpdateService)
    {
        $true
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name AllowMUUpdateService -Value 1 -Force | Out-Null
        }
        $false
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name AllowMUUpdateService -Value 0 -Force | Out-Null

        }
    }
}

function SetAlwaysAutoRebootAtScheduledTime
{
    Param(
        [Parameter(Mandatory=$true)]
        [bool]$AlwaysAutoRebootAtScheduledTime
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    switch ($AlwaysAutoRebootAtScheduledTime)
    {
        $true
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name AlwaysAutoRebootAtScheduledTime -Value 1 -Force | Out-Null
        }
        $false
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name AlwaysAutoRebootAtScheduledTime -Value 0 -Force | Out-Null
        }
    }
}

function SetAlwaysAutoRebootAtScheduledTimeMinutes
{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(15,180)]
        [int]$AlwaysAutoRebootAtScheduledTimeMinutes
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    New-ItemProperty -Path $RegKey -PropertyType DWord -Name AlwaysAutoRebootAtScheduledTimeMinutes -Value $AlwaysAutoRebootAtScheduledTimeMinutes -Force | Out-Null
}

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

function SetAutomaticMaintenanceEnabled
{
    Param(
        [Parameter(Mandatory=$true)]
        [bool]$AutomaticMaintenanceEnabled
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    switch ($AutomaticMaintenanceEnabled)
    {
        $true
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name AutomaticMaintenanceEnabled -Value 1 -Force | Out-Null
        }
        $false
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name AutomaticMaintenanceEnabled -Value 0 -Force | Out-Null
        }
    }
}

function SetIncludeRecommendedUpdates
{
    Param(
        [Parameter(Mandatory=$true)]
        [bool]$IncludeRecommendedUpdates
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    switch ($IncludeRecommendedUpdates)
    {
        $true
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name IncludeRecommendedUpdates -Value 1 -Force | Out-Null
        }
        $false
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name IncludeRecommendedUpdates -Value 0 -Force | Out-Null
        }
    }
}

function SetNoAutoUpdate
{
    Param(
        [Parameter(Mandatory=$true)]
        [bool]$NoAutoUpdate
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    switch ($NoAutoUpdate)
    {
        $true
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name NoAutoUpdate -Value 1 -Force | Out-Null
        }
        $false
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name NoAutoUpdate -Value 0 -Force | Out-Null
        }
    }
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

function SetScheduledInstallEveryWeek
{
    Param(
        [Parameter(Mandatory=$true)]
        [bool]$ScheduledInstallEveryWeek
    )

    $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    
    switch ($ScheduledInstallEveryWeek)
    {
        $true
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name ScheduledInstallEveryWeek -Value 1 -Force | Out-Null
        }
        $false
        {
            New-ItemProperty -Path $RegKey -PropertyType DWord -Name ScheduledInstallEveryWeek -Value 0 -Force | Out-Null
        }
    }
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

$AllowMUUpdateService = $true #Manage whether to scan for app updates from Microsoft Update.
$AlwaysAutoRebootAtScheduledTime = $true #Force automatic restarts after important updates
$AlwaysAutoRebootAtScheduledTimeMinutes = 60 #Sets the timer to warn a signed-in user that a restart is going to occur
$AuOptions = 4 #2 = Notify before download, 3 = Automatically download and notify of installation, 4 = Automatic download and scheduled installation, 5 = Automatic Updates is required, but end users can configure it.
$AutomaticMaintenanceEnabled = $true #Install during automatic maintenance
$IncludeRecommendedUpdates = $true #Turn on recommended updates via Automatic Updates
$NoAutoUpdate = $false #Turn off automatic updates
$ScheduledInstallDay = 0 #Scheduled install day (0 = every day, 1 = Sunday, 2 = Monday, etc.)
$ScheduledInstallEveryWeek = $true #Install updates every week
$ScheduledInstallTime = 3 #Install updates time

SetAllowMUUpdateService -AllowMUUpdateService $AllowMUUpdateService
SetAlwaysAutoRebootAtScheduledTime -AlwaysAutoRebootAtScheduledTime $AlwaysAutoRebootAtScheduledTime
SetAlwaysAutoRebootAtScheduledTimeMinutes -AlwaysAutoRebootAtScheduledTimeMinutes $AlwaysAutoRebootAtScheduledTimeMinutes
SetAuOptions -AuOptions $AuOptions
SetAutomaticMaintenanceEnabled -AutomaticMaintenanceEnabled $AutomaticMaintenanceEnabled
SetIncludeRecommendedUpdates -IncludeRecommendedUpdates $IncludeRecommendedUpdates
SetNoAutoUpdate -NoAutoUpdate $NoAutoUpdate
SetScheduledInstallDay -ScheduledInstallDay $ScheduledInstallDay
SetScheduledInstallEveryWeek -ScheduledInstallEveryWeek $ScheduledInstallEveryWeek
SetScheduledInstallTime -ScheduledInstallTime $ScheduledInstallTime

#Restart Windows Update service
Get-Service -Name wuauserv | Restart-Service