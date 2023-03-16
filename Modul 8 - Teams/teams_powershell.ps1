
##########################
# Installasjon av Teams modul #
##########################

# Installerer modulen for Microsoft Teams
Get-Module MicrosoftTeams
Install-Module MicrosoftTeams
# Koble til Microsoft Teams
Connect-MicrosoftTeams
# Lister ut alle Teams
Get-Team
# Velger kun å vise utvalgt informasjon
Get-Team | Select-Object DisplayName, Description, GroupID
# Åpner et vindu som gir mulighet til å få PowerShell til å liste ut hvordan man ville skrevet en bestemt kommando.
# Setter jeg eksempelvis inn navnet  "iOS" får jeg resultatet "Get-Team -Displayname iOS"
Show-Command -name "Get-Team"

# Hjelpemodulen tilknyttet Get-Team
Get-Help -Name Get-Team -Examples

#########################
# Editere eksisterende Teams #
#########################

#Gir mulighet for å velge et konkret Team å jobbe mot'
Set-Team
#Eksempel på justering mot Teamet "Velferdsgruppen"
$teamEdit = Get-Team -DisplayName "Velferdsgruppen"
#Tester variabel
$teamEdit
# Velger det konkrete teamet å jobbe mot
Set-Team -GroupID $teamEdit.GroupId 
# Endrer Description av teamet via PowerShell
Set-Team -GroupID $teamEdit.GroupId -Description "Dette er en justert beskrivelse gjort i PowerShell"
# Endrer deretter Visibility fra Private til Public
Set-Team -GroupID $teamEdit.GroupId -Visibility "Public"

# Hjelpemodulen tilknyttet Set-Team
Get-Help -Name Set-Team -Examples

####################
# Opprette et nytt Team #
####################

# Gir mulighet for opprettelse av et nytt Team
New-Team
# Eksempel på oppretteløse av et nytt Team
$juleTeam = New-Team -DisplayName "Julebord2023" -Description "Koordinering av årets julebord" -Visibility "Private"
#Legger til medlemmer i Teamet
Add-Teamuser -GroupID $juleTeam.GroupId -User "Melis.Holtmoen@randombedrift.onmicrosoft.com"
Add-Teamuser -GroupID $juleTeam.GroupId -User "Tine.Kaland@randombedrift.onmicrosoft.com"
Add-Teamuser -GroupID $juleTeam.GroupId -User "Arne.Belinda@randombedrift.onmicrosoft.com"
#Legger til kanaler til Teamet
New-TeamChannel -GroupId $juleTeam.GroupId -DisplayName "Alkohol"
New-TeamChannel -GroupId $juleTeam.GroupId -DisplayName "Catering"
New-TeamChannel -GroupId $juleTeam.GroupId -DisplayName "Underholdning"

$smøreTeam = New-Team -DisplayName "Smøretur" -Description "Firmatur med kunde til Tahiti" -Visibility "Private"
#Legger til medlemmer i Teamet
Add-Teamuser -GroupID $smøreTeam.GroupId -User "bjarne.betjent@randombedrift.onmicrosoft.com"
Add-Teamuser -GroupID $smøreTeam.GroupId -User "marius.holtmoen@randombedrift.onmicrosoft.com"
Add-Teamuser -GroupID $smøreTeam.GroupId -User "ellie.holtmoen@randombedrift.onmicrosoft.com"
#Legger til kanaler til Teamet
New-TeamChannel -GroupId $smøreTeam.GroupId -DisplayName "Booking"
New-TeamChannel -GroupId $smøreTeam.GroupId -DisplayName "Seminar"
New-TeamChannel -GroupId $smøreTeam.GroupId -DisplayName "Økonomi"


$AllTeams = (Get-Team).GroupID
$Teamlist =@()

# For hvert Team som ligger i $AllTeams, legges det et objekt i $TeamList basert på variabelverdiene for hver iterasjon i kodeblokken.
Foreach ($Team in $AllTeams) { 
    $TeamGUID = $Team.ToString()
    $TeamName = (Get-Team | ? { $_.GroupID -eq $Team }).DisplayName
    $TeamOwner = (Get-TeamUser -GroupId $Team | ? { $_.Role -eq 'Owner' }).Name
    $TeamMember = (Get-TeamUser -GroupId $Team | ? { $_.Role -eq 'Member' }).Name

    $TeamList = $TeamList + [PSCustomObject]@{TeamName = $TeamName; TeamObjectID = $TeamGUID; TeamOwners = $TeamOwner -join ', '; TeamMembers = $TeamMember -join ', ' }
}
#Eksporterer listen over Teams til en .csv fil
$Teamlist | Export-Csv "C:\Users\mariu\Desktop\TeamsData.csv" -NoTypeInformation

# Lag et nytt Team ved bruk av variabler

$teamName = "Mitt SuperDuper Team"
$teamDescription = "Kule folk til et kult prosjekt"
$teamOwner = "marius@randombedrift.onmicrosoft.com"
$teamVisibility = "Private"
$teamEditMessagesPolicy = $false
$teamDeliteMessagesPolicy = $false
$teamChannels = @(“Baksnakking”, “Prokrastinering”)
$teamMembers = @(“marius@randombedrift.onmicrosoft.com”, “tine.kaland@randombedrift.onmicrosoft.com”)
$mailnick = ""

$teamDetails = New-Team -DisplayName $teamName -Description $teamDescription -Owner $teamOwner -Visibility $teamVisibility -AllowUserEditMessages $teamEditMessagesPolicy -AllowOwnerDeleteMessages $teamDeliteMessagesPolicy

for ($i = 0; $i -lt $teamChannels.length; $i++) {
    New-TeamChannel -GroupId $teamDetails.GroupId -DisplayName $teamChannels[$i]
}

for ($i = 0; $i -lt $teamMembers.length; $i++) {
    Add-TeamUser -GroupId $teamDetails.GroupId -User $teamMembers[$i] -role ”Member”
}
Disconnect-MicrosoftTeams





# Hjelpemodulen tilknyttet New-Team
Get-Help -Name New-Team -Examples