function Get-RandomPassword
{
    param(
        [int]$Length=32
    )
    $Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    $Random = 1..$Length | ForEach-Object { Get-Random -Maximum $Characters.Length }
    $Password = -join $Characters[$Random]

    return $Password
}

$AdminPassword = Get-RandomPassword -Length 32
WriteLog -Message "Changing Password for Administrator user" -Severity Information
Set-LocalUser -Name Administrator -Password (ConvertTo-SecureString -String $AdminPassword -AsPlainText -Force) -AccountNeverExpires -PasswordNeverExpires $true
Write-Warning -Message "Password for Administrator: $AdminPassword"
Read-Host -Prompt "Press any key to continue"
