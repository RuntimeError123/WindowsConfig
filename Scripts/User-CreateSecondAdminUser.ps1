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

$SecondAdminUserName = "Lennaert_Admin"
$SecondAdminFullName = "Lennaert Bosch Admin"

$SecondAdminPassword = Get-RandomPassword -Length 32
WriteLog -Message "Adding secondary admin user. Name: $SecondAdminUserName, FullName: $SecondAdminFullName"
New-LocalUser -Name $SecondAdminUserName -FullName $SecondAdminFullName -Password (ConvertTo-SecureString -String $SecondAdminPassword -AsPlainText -Force) -AccountNeverExpires -PasswordNeverExpires | Out-Null
Add-LocalGroupMember -Group Administrators -Member $SecondAdminUserName
Write-Warning -Message "Password for $SecondAdminUserName : $SecondAdminPassword"
Read-Host -Prompt "Press any key to continue"
