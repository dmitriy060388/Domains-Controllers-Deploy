Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools

$params = @{
    CAType              = "EnterpriseRootCa"
    CryptoProviderName  = "RSA#Microsoft Software Key Storage Provider"
    KeyLength           = 2048
    HashAlgorithmName   = "SHA256"
    ValidityPeriod      = "Years"
    ValidityPeriodUnits = 10
    Force = $true
}

Install-AdcsCertificationAuthority @params