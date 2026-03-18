# добавление текущего пользователя в автоматический вход в систему
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = $Env:UserName
$DefaultPassword = "P@ssw0rd!"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1"
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername"
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword"

# смена имени компьютера
Rename-Computer -NewName "dc1"

# сохранить название и индекс сетевого интерфейса для настройки сети
$name_ethernet = Get-NetAdapter | ForEach-Object {Write-Output "$($_.Name)"}
$index_ethernet = Get-NetAdapter | ForEach-Object {Write-Output "$($_.ifIndex)"}

# установка статического IP адреса
Get-NetAdapter -Name $name_ethernet| New-NetIPAddress –IPAddress 192.168.1.1  -PrefixLength 24

# отключение протокола IPv6
Disable-NetAdapterBinding -Name $name_ethernet -ComponentID 'ms_tcpip6'

# настройка DNS
Set-DNSClientServerAddress –InterfaceIndex $index_ethernet –ServerAddresses 127.0.0.1


# установка доменных служб
Install-windowsfeature AD-domain-services
Install-WindowsFeature -Name DNS
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature RSAT-DNS-Server
Enable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol-Client" -all -norestart


# необходимо перезагрузить компьютер, перед повышением роли
shutdown /r /t 0