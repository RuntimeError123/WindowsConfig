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

$SecurityPolicyName = "Security"
$MaximumPasswordAge = "-1"
$PasswordComplexity = "0"

WriteLog -Message "Configuring password policy with MaximumPasswordAge: $MaximumPasswordAge, PasswordComplexity: $PasswordComplexity" -Severity Information
$TempFile = Join-Path -Path $env:TEMP -ChildPath secpol.ini
Start-Process C:\Windows\System32\SecEdit.exe -ArgumentList "/export /cfg $TempFile" -Wait

Set-IniSetting -Path $TempFile -Setting MaximumPasswordAge -Value $MaximumPasswordAge -Overwrite $true
Set-IniSetting -Path $TempFile -Setting PasswordComplexity -Value $PasswordComplexity -Overwrite $true

Start-Process C:\Windows\System32\SecEdit.exe -ArgumentList "/configure /db $env:windir\$SecurityPolicyName.sdb /cfg $TempFile" -Wait

Remove-Item -Path $TempFile