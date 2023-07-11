$SetKeyManagementServiceMachine = "kms.services.home.l3n.nl"
$SetKeyManagementServicePort = 1688

$SoftwareLicensingService = Get-WmiObject -query "select * from SoftwareLicensingService"

$SoftwareLicensingService.SetKeyManagementServiceMachine($SetKeyManagementServiceMachine) | Out-Null
$SoftwareLicensingService.SetKeyManagementServicePort($SetKeyManagementServicePort) | Out-Null
$SoftwareLicensingService.RefreshLicenseStatus() | Out-Null
