
# Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

#Importerer csv fil
$kontakter = Import-Csv -Path "Modul 4-7 Exchange administrasjon\05-Nye brukere.csv" -Delimiter ";"
Write-Host $kontakter

$PasswordProfile = @{
    Password = 'xWwvJ]6NMw+bWH-d'
}

#Legge til brukere
foreach ($kontakt in $kontakter) {
    New-MgUser -DisplayName $kontakt.DisplayName `
        -UserPrincipalName $kontakt.UserPrincipalName `
        -PasswordProfile $PasswordProfile `
        -MailNickname $kontakt.MailNickName `
        -AccountEnabled `
        -Mail $kontakt.Altmailaddr
}
#Kontrollerer at brukerne har blitt lagt til
Get-MgUser | Format-Table
Get-MgUser | Select-Object Id, DisplayName, UserPrincipalName
