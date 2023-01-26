
#   Finner og installerer modulene nedenfor
#   AzureAD
Find-Module -Name AzureAD | Install-Module
Import-Module AzureAD
Connect-AzureAD

#   MSOnline
Find-Module MSOnline | Install-Module
Import-Module MSOnline
Connect-MsolService

#   Microsoft Graph
Find-Module Microsoft.Graph | Install-Module
Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Directory.ReadWrite.All"

#Sjekk hvilke kommandoer som er tilgjengelig, samt liste ut demobrukere
Get-Command -Module MSOnline
Get-Command -Module AzureAD
Get-MsolUser
Get-Help -Name New-MsolUser -Examples

###################################MSOnline#####################################################################

#Oppretter en ny testbruker ved hjelp av MSOnline
New-MsolUser `
    -UserPrincipalName "random.randomsen@randombedrift.onmicrosoft.com" `
    -DisplayName "Random Randomsen" `
    -FirstName "Random" `
    -LastName "Randomsen"

#Opprette en gruppe for testing med selv-service reset passord med Msol-modulen
Get-Help -Name New-MsolGroup -Examples
New-MsolGroup -DisplayName "m365_pswd_reset" -Description "Gruppe bruklt til self-service passord reset"
Get-MsolGroup

Get-MsolUser
Get-MsolUser | Select-Object ObjectID, UserPrincipalName
Get-Help -Name Add-MsolGroupMember -Examples

#Legger til en enkeltbruker i en gruppe
Add-MsolGroupMember -GroupObjectid "04177ae6-5c54-48e5-b1c9-8bc92ea0d5ca" `
    -groupmemberType "User" `
    -groupMemberObjectId "dd32904b-0925-4302-8df1-52a6700672ad"

#Sjekker at brukeren faktisk har blitt lagt til i gruppen
Get-Help -Name Get-MsolGroupMember -Examples
Get-MsolGroupMember -groupObjectid "04177ae6-5c54-48e5-b1c9-8bc92ea0d5ca"

#Legger til flere brukere i en gruppe ved hjelp av en ForEach-løkke
Get-MsolUser | Select-Object ObjectID, UserPrincipalName
$users = Get-MsolUser | Select-Object ObjectID, UserPrincipalName
foreach ($user in $users) {
    Add-MsolGroupMember -groupObjectid "04177ae6-5c54-48e5-b1c9-8bc92ea0d5ca" -groupmemberType "User" -groupMemberObjectId $user.ObjectID
}
#Kontrollerer at brukerne nå er lagt til gruppen
Get-MsolGroupMember -groupObjectid "04177ae6-5c54-48e5-b1c9-8bc92ea0d5ca"

#Velger nå å slette gruppen
Remove-MsolGroup -Objectid "04177ae6-5c54-48e5-b1c9-8bc92ea0d5ca"

###################################AzureAD#####################################################################

$PasswordProfile = @{
    Password = 'xWwvJ]6NMw+bWH-d'
    }
#Opprette en ny bruker
Get-Help New-AzureADUser -Examples
New-AzureADUser -DisplayName "Test Testesen" -PasswordProfile $PasswordProfile -UserPrincipalName "test.testesen@randombedrift.onmicrosoft.com" -AccountEnabled $true -MailNickName "Newuser"

Get-Help -Name New-AzureADGroup -Examples
#Oppretter en ny gruppe
New-AzureADGroup -DisplayName "m365_e5_lisence" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
#Kontrollerer at gruppen ble oppretet
Get-AzureADGroup

#Lister opp alle brukere
Get-AzureADUser

#Legger til en ny bruker
Get-Help -Name Add-AzureADGroupMember -Examples
Add-AzureADGroupMember -Objectid "bcc6c413-12fe-47c5-b299-1fdebe137c9d" -RefObjectId "dd32904b-0925-4302-8df1-52a6700672ad"
#Kontrollerer at bruker har blitt lagt til gruppen
Get-AzureADGroupMember -Objectid "bcc6c413-12fe-47c5-b299-1fdebe137c9d"
#Legger til flere brukere i en gruppe ved hjelp av en ForEach-løkke
$users = Get-AzureADUser | Select-Object ObjectID, UserPrincipalName
foreach($user in $users) {
    Add-AzureADGroupMember -Objectid "bcc6c413-12fe-47c5-b299-1fdebe137c9d" -RefObjectId $user.ObjectID
}
Get-AzureADGroupMember -Objectid "bcc6c413-12fe-47c5-b299-1fdebe137c9d"

###############################Legge til brukere via .csv fil###########################################################

$myusers = import-Csv "Modul 2 - Kjernefunksjoner i M365\02-intro-powershell-m365.csv" -Delimiter ";"
write-host $myusers

foreach ($user in $myusers) {
    $PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password=$user.Password
    New-AzureADUser `
        -GivenName $user.GivenName `
        -SurName $user.SurName `
        -DisplayName $user.DisplayName `
        -UserPrincipalName $user.UserPrincipalName `
        -MailNickName $user.MailNickName `
        -OtherMails $user.Altmailaddr `
        -PasswordProfile $PasswordProfile `
        -AccountEnabled $true
}

# Rydde opp etter testing
Get-AzureADUser -SearchString "Nordmann"
Remove-AzureADUser -ObjectId ""
Get-AzureAdGroup
Remove-AzureADGroup -ObjectID "bcc6c413-12fe-47c5-b299-1fdebe137c9d"

###################################Microsoft.Graph################################################################
#Bruk av Microsoft Graph
Get-MgUser  | Format-List  ID, DisplayName, Mail, UserPrincipalName
Get-MgUser  | Select-Object  ID, DisplayName, Mail, UserPrincipalName | ft

#Lager en passordvariabel
$PasswordProfile = @{
    Password = 'xWwvJ]6NMw+bWH-d'
    }

#Oppretter en ny bruker og benytter passordvariabelen for å sette passord
New-MgUser -DisplayName "Mons Monsen" `
    -UserPrincipalName "Mons.Monsen@randombedrift.onmicrosoft.com" `
    -PasswordProfile $PasswordProfile `
    -AccountEnabled `
    -MailNickname "Mons.Monsen"
#Kontrollerer at brukeren er opprettet
Get-MgUser -UserID 0d78c356-e44f-42fb-9f5c-e14d3c716851

#Legger til ytterligere informasjon i til brukeren. Kan kontrolleres i Azure AD da det kan ta litt tid å oppdatere seg
Update-MgUser -UserID 0d78c356-e44f-42fb-9f5c-e14d3c716851 `
-Department "IT" `
-Company "Learn IT"


Get-MgUser -UserID 0d78c356-e44f-42fb-9f5c-e14d3c716851 | format-list givenname, surname, UserPrincipalName, Department
$testvariable = Get-MgUser -UserID 79d5b134-ddac-4249-a5e3-4cefe327d29a | format-list givenname, surname, UserPrincipalName 
$testvariable
