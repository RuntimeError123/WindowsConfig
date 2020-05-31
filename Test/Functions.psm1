function GetSCWindowsUpdate
{
    $RegKey = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -ErrorAction SilentlyContinue

    $ReturnObject = New-Object -TypeName psobject

    if ($RegKey.NoAutoUpdate -eq 1)
    {
        $ReturnObject | Add-Member -MemberType NoteProperty -Name NoAutoUpdate -Value $true 
    }
    else
    {
        switch ($RegKey.AUOptions)
        {
            "3"
            {   
                $Value = "DownloadOnly"
                $ReturnObject | Add-Member -MemberType NoteProperty -Name Options -Value $Value
            }
            "4"
            {
                $Value = "Automatic"
                $ReturnObject | Add-Member -MemberType NoteProperty -Name Options -Value $Value
            }
        }

        if ($RegKey.ScheduledInstallDay)
        {
            $ReturnObject | Add-Member -MemberType NoteProperty -Name "ScheduledInstallDay" -Value $RegKey.ScheduledInstallDay
        }
        
        if ($Regkey.ScheduledInstallTime)
        {
            $ReturnObject | Add-Member -MemberType NoteProperty -Name "ScheduledInstallTime" -Value $RegKey.ScheduledInstallTime
        }
    }
    return $ReturnObject
}

function VerifySCWindowsUpdate
{
    param(
        [string]$NoAutoUpdate,
        [string]$Options,
        [string]$ScheduledInstallDay,
        [string]$ScheduledInstallTime,
        [Parameter(Mandatory=$true)][psobject]$ReferenceObject
    )

    $VerifyObject = New-Object -TypeName psobject
    
    if ($NoAutoUpdate)
    {
        $VerifyObject | Add-Member -MemberType NoteProperty -Name NoAutoUpdate -Value $NoAutoUpdate
    }
    
    if ($Options)
    {
        $VerifyObject | Add-Member -MemberType NoteProperty -Name Options -Value $Options
    }

    if ($ScheduledInstallDay)
    {
        $VerifyObject | Add-Member -MemberType NoteProperty -Name ScheduledInstallDay -Value $ScheduledInstallDay
    }

    if ($ScheduledInstallTime)
    {
        $VerifyObject | Add-Member -MemberType NoteProperty -Name ScheduledInstallTime -Value $ScheduledInstallTime
    }

    $Compare = [String]$ReferenceObject -eq $VerifyObject

    return $Compare
}