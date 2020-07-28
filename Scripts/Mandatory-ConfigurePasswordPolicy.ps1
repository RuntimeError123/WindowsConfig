function Set-IniSetting
{
    param(
        $Path,
        $Setting,
        $Value,
        [bool]$Overwrite
    )
    $IniContent = Get-Content -Path $Path
    $Output = $IniContent | ForEach-Object { if ($_ -like "$Setting*") { "$Setting = $Value"} else { $_ }}
    if ($Overwrite -eq $true)
    {
        $Output | Set-Content -Path $Path
    }
    else
    {
        return $Output
    }
}

$SecurityPolicyName = "L3NSecurity"

$TempFile = Join-Path -Path $env:TEMP -ChildPath secpol.ini
Start-Process C:\Windows\System32\SecEdit.exe -ArgumentList "/export /cfg $TempFile" -Wait

Set-IniSetting -Path $TempFile -Setting MaximumPasswordAge -Value -1 -Overwrite $true
Set-IniSetting -Path $TempFile -Setting PasswordComplexity -Value 0 -Overwrite $true

Start-Process C:\Windows\System32\SecEdit.exe -ArgumentList "/configure /db $env:windir\$SecurityPolicyName.sdb /cfg $TempFile" -Wait

Remove-Item -Path $TempFile