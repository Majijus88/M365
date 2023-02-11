
#Installerer nødvendig modul
Find-Module -Name ExchangeOnlineManagement | Install-Module
#Importerer modulen
Import-Module -Name ExchangeOnlineManagement
#Kobler til Exchange Online - Får prompt om å logge inn via nettleser
Connect-ExchangeOnline

#Søker opp mailbokser
Get-EXOMailbox | Select-Object DisplayName, UserPrincipalName

#####################################
#Nyttige kommandoer - Distirbusjonsgrupper#
#####################################
Get-Help -Name New-DistributionGroup -Examples
Get-DistributionGroup | Select-Object DisplayName, PrimarySmtpAddress
#Syntax for opprettelse av ny DistributionGroup
New-DistributionGroup -Name " " -DisplayName " " -PrimarySmtpAddress " "
#Eksempel
New-DistributionGroup -Name "Alle-HR" -DisplayName "Alle HR" -PrimarySmtpAddress "alle-hr-pwsh@randombedrift.onmicrosoft.com"
#Syntax for å legge til et nytt medlem
Get-Help -Name Add-DistributionGroupMember -Examples
Add-DistributionGroupMember -Identity " " -Member " " -PrimarySmtpAddress
#Eksempel
Add-DistributionGroupMember -Identity "Alle-HR" -Member "Tine Kaland"
#Kontrollerer at medlemmet har blitt lagt til
Get-DistributionGroupMember -Identity "Alle HR"

#############################
#Hvordan opprette en ny mailboks#
#############################

Get-Help -Name New-Mailbox -Examples
#Syntax for å opprette en ny mailboks
New-Mailbox -Shared -Name " " -DisplayName " " -PrimarySmtpAddress " "
#Eksempel
New-Mailbox -Shared -Name "IT-Support" -DisplayName "IT-Support" -PrimarySmtpAddress "itsupport@randombedrift.onmicrosoft.com"
#Kontrollerer at mailboksen er opprettet. Piper ved hjelp av Where-Object for å bare vise mailbokser som er "shared"
Get-EXOMailbox | Select-Object DisplayName, RecipientTypeDetails | Where-Object {$_.RecipientTypeDetails -eq "SharedMailBox"}

#################################################
#Hvordan gi ansatte mulighet til å bruke en shared mailboks#
#################################################

#Syntax
Get-Mailbox -Identity " " | Add-MailboxPermission -User " " -AccessRights "FullAccess" -InheritanceType "All"
#Eksempel
Get-Mailbox -Identity "IT-Support" | Add-MailboxPermission -User "tine.kaland@randombedrift.onmicrosoft.com" -AccessRights FullAccess -InheritanceType All
#Kontrollerer at den ansatte nå har tilgang til mailboksen
Get-MailboxPermission -Identity "IT-Support"
#Gir den ansatte "Send As" rettigheter
Add-RecipientPermission -Identity "IT-Support" -AccessRights SendAs -Trustee "tine.kaland@randombedrift.onmicrosoft.com" -Confirm:$false

########################
#Dynamic Distribution Group#
########################

Get-Help -Name New-DynamicDistributionGroup -Examples
#Syntax
New-DynamicDistributionGroup -Name " " -IncludedRecipients " " -ConditionalStateOrProvince " "
#Eksempel
Get-DynamicDistributionGroup
New-DynamicDistributionGroup -Name "Alle Tromsø" -IncludedRecipients "MailboxUsers " -ConditionalStateOrProvince "Tromsø"

#############
#M365 Gruppe#
#############

Get-Help -Name New-UnifiedGroup
#Syntax
New-UnifiedGroup -DisplayName " "
#Eksempel
New-UnifiedGroup -DisplayName "Project Y"
#Kontrollerer at gruppen er opprettet
Get-UnifiedGroup
#Gi mulighet til å sende mailer til gruppen fra utenfor organisasjonen
Set-UnifiedGroup  -Identity "Prosjekt Y" -PrimarySmtpAddress "prosjekty@randombedrift.onmicrosoft.com" -RequireSenderAuthenticationEnabled:$false
#Legge til medlemmer i gruppen
Add-UnifiedGroupLinks -Identity "Prosjekt Y" -LinkType "Members" -Links "tine.kaland@randombedrift.onmicrosoft.com"  

#######################
#Opprette en rom-mailboks#
#######################

#Sjekker hva slags rom-mailbokser som allerde finnes
Get-EXOMailbox | Select-Object DisplayName, RecipientTypeDetails | Where-Object {$_.RecipientTypeDetails -eq "RoomMailBox"}
#Opprette ny rom-mailboks
New-Mailbox -Name "Igloo@randombedrift.onmicrosoft.com" -DisplayName "Igloo" -Alias "Igloo" -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString -String FfdE123e!wes_ -AsPlainText -Force)
#Kontrollerer at rom-mailboksen er blitt opprettet
Get-EXOMailbox | Select-Object DisplayName, RecipientTypeDetails | Where-Object {$_.RecipientTypeDetails -eq "SharedMailBox"}
#Setter kapasiteten på roomet til maks 12 personer
Get-Mailbox -Identity "Igloo" | Set-Mailbox -ResourceCapacity 12
