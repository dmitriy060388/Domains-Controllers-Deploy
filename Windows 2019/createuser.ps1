# создание доменного администратора на латинице
$org=Get-ADDomain | Select-Object -ExpandProperty UsersContainer
$username="administrator"
$forest=Get-ADDomain | Select-Object -ExpandProperty Forest
$phone=+79999999999
New-ADUser -Name $username -GivenName $username -Path $org -EmailAddress "$username@$forest" `
-AccountExpirationDate "01.01.2045" -Country "RU" `
-OfficePhone $phone `
-PasswordNeverExpires 1 -Enabled $true -AccountPassword (ConvertTo-SecureString P@ssw0rd! -AsPlainText -force)


# добавление нового администратора в необходимые группы
Add-ADPrincipalGroupMembership -Identity $username `
-MemberOf "Администраторы",
 "Администраторы схемы", 
 "Администраторы предприятия", 
 "Администраторы домена"