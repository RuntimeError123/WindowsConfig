$CertificateFolder = Join-Path -Path ($PSScriptRoot | Split-Path -Parent) -ChildPath "Certificates"
$CertificateFiles = Get-ChildItem -Path $CertificateFolder
$CertificateStore = "Cert:\LocalMachine\Root"

WriteLog -Message "Importing $($CertificateFiles.Name -join ", ") to store $CertificateStore" -Severity Information
foreach ($CertificateFile in $CertificateFiles)
{
    Import-Certificate -FilePath $CertificateFile.FullName -CertStoreLocation $CertificateStore | Out-Null
}