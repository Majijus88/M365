
# Microsoft Graph
Find-Module Microsoft.Graph | Install-Module
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

#Importerer csv fil
$kontakter = Import-Csv -Path "Modul 3 - Azure AD\03-Nye brukere.csv" -Delimiter ";"
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

Get-MgUser | Format-Table
Get-MgUser | Select-Object Id, DisplayName, UserPrincipalName
