param (
    [array]$Optional,
    [bool]$UserScripts = $true,
    [bool]$Reboot = $true
)

#Set computername
$NewComputerName = Read-Host -Prompt "Current computer name: $env:COMPUTERNAME, New computer name: "
Rename-Computer -NewName $NewComputerName -Restart:$false -Confirm:false
#Scripts

$ScriptsFolder = Join-Path -Path $PSScriptRoot -ChildPath "Scripts"
$MandatoryScripts = Get-ChildItem -Path $ScriptsFolder -Filter Mandatory-*.ps1
$ScriptsToRun = $MandatoryScripts



if ($Optional)
{
    $OptionalScriptFiles = $Optional -split "," | ForEach-Object {Get-Childitem -Path $ScriptsFolder -Filter Optional-$_.ps1 }
    $ScriptsToRun += $OptionalScriptFiles
}

if ($UserScripts -eq $true)
{
    $UserScriptFiles = Get-Childitem -Path $ScriptsFolder -Filter "User-*.ps1"
    $ScriptsToRun += $UserScriptFiles
}

Write-Host "Will run scripts: `n$((($ScriptsToRun | Sort-Object -Property Name).Name) -join "`n")"

