Param($pwspName,$pcpName)


#Install the required Modules
Install-Module -Name Az -Repository PSGallery -Force
Install-Module -Name MicrosoftPowerBIMgmt

#Connect to PowerBI Services
Connect-PowerBIServiceAccount

#Get the workspace Name as parameter and assign it to a local variable
$wspName = $pwspName

#Create a new workspace using the workspace name
New-PowerBIWorkspace -Name $wspName

#Get the ID of the workspace created and assign it to a variable
$wspID = (Get-PowerBIWorkspace -Name $wspName | Select-Object -ExpandProperty Id).ToString()

#Get the capacity Name as parameter and assign it to a local variable
$cpName = $pcpName

#Get the Capacity ID based on capacity name supplied and assign it to a variable
$cpID = (Get-PowerBICapacity -Scope Organization | Where-Object { $_.DisplayName -Eq "cpdataanalyticstest" } | Select-Object -ExpandProperty Id).ToString()

#assign the capacity to the workspace
Set-PowerBIWorkspace -Scope Organization -Id $wspID -CapacityId $cpID
