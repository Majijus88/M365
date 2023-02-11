
#Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

#Importerer csv fil
$kontakter = Import-Csv -Path "users_10.02.2023 19_32_11.csv" -Delimiter ","
Write-Host $kontakter

#Legger hver kontakt i csv-filen inn i gruppen "Alle ansatte"
foreach($kontakt in $kontakter) {
    Add-DistributionGroupMember -Identity "Alle ansatte" `
     -Member $kontakt.Visningsnavn `
}

