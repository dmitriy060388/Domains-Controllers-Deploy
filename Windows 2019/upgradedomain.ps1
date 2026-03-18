$pass = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
$params = @{
    CreateDnsDelegation = $false
    DatabasePath = "C:\Windows\NTDS"
    DomainMode = "WinThreshold"
    DomainName = "corp.test"
    DomainNetbiosName = "CORP"
    ForestMode = "WinThreshold"
    InstallDns = $true
    LogPath = "C:\Windows\NTDS"
    NoRebootOnCompletion = $false
    SysvolPath = "C:\WIndows\SYSVOL"
    SafeModeAdministratorPassword = $pass
    Force = $true
}
Install-ADDSForest @params


# после повышения роли до контроллера домена, компьютер перезагрузится
# компьтер будет настраивать параметры около 5 минут