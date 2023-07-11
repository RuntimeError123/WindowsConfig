param (
    [string]$Optional,
    [bool]$SetComputerName = $true,
    [bool]$UserScripts = $true,
    [bool]$Reboot = $true
)

$WindowsConfigVersion = "0.1"
$global:PILSLogFilePrefix = "WindowsConfig"
$global:PILSLogFolder = "C:"

#Importing PILS module
Import-Module -Name .\PILS\Pils.psm1
WriteLog -CustomMessage "################################################################################"
WriteLog -Message "Starting WindowsConfig version $WindowsConfigVersion" -Severity Information
WriteLog -Message "Optional Scripts: $Optional" -Severity Information
WriteLog -Message "Set ComputrName: $SetComputerName" -Severity Information
WriteLog -Message "User Scripts: $UserScripts" -Severity Information
WriteLog -Message "Reboot: $Reboot" -Severity Information

#Set computer name
if ($SetComputerName -eq $true)
{
    WriteLog -Message "Changing computer name" -Severity Information
    $NewComputerName = Read-Host -Prompt "Press enter to skip. Current computer name: $env:COMPUTERNAME, New computer name"
    if ($NewComputerName)
    {
        WriteLog -Message "Changing computer name to $NewComputerName" -Severity Information
        Rename-Computer -NewName $NewComputerName -Restart:$false -Confirm:$false -WarningAction SilentlyContinue
    }
    else
    {
        WriteLog -Message "Skipping computer name configuration" -Severity Warning   
    }
}

#Scripts
$ScriptsFolder = Join-Path -Path $PSScriptRoot -ChildPath "Scripts"
$MandatoryScripts = Get-ChildItem -Path $ScriptsFolder -Filter Mandatory-*.ps1
$ScriptsToRun = $MandatoryScripts

if ($Optional)
{
    $OptionalScriptFiles = $Optional -split "," | ForEach-Object {Get-Childitem -Path $ScriptsFolder -Filter Optional-$_.ps1 -ErrorAction Stop }
    $ScriptsToRun += $OptionalScriptFiles
}

if ($UserScripts -eq $true)
{
    $UserScriptFiles = Get-Childitem -Path $ScriptsFolder -Filter "User-*.ps1"
    $ScriptsToRun += $UserScriptFiles
}

WriteLog -Message "Will run scripts: $((($ScriptsToRun | Sort-Object -Property Name).Name) -join ", ")" -Severity Information
foreach ($ScriptToRun in $ScriptsToRun)
{
    WriteLog -Message "Starting $($ScriptToRun.Name)" -Severity Information
    & $ScriptToRun.FullName
    WriteLog -Message "Finished $($ScriptToRun.Name)" -Severity Information
}

if ($Reboot -eq $true)
{
    WriteLog -Message "Rebooting..." -Severity Information
    Start-Sleep -Seconds 5
    WriteLog -CustomMessage "################################################################################"
    WriteLog -CustomMessage ""
    Restart-Computer -Confirm:$false
}
else
{
    WriteLog -Message "Not rebooting, please reboot manually" -Severity Warning    
    WriteLog -CustomMessage "################################################################################"
    WriteLog -CustomMessage " "
}