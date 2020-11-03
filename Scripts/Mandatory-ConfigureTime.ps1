#Configure TimeZone
$TimeZone = "W. Europe Standard Time"
WriteLog -Message "Configuring timezone to $TimeZone" -Severity Information
Set-TimeZone -Name $TimeZone