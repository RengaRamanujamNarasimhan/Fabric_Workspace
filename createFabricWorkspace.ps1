Param($pcpName,$pwspName)


#Install the required Modules
Install-Module -Name Az -Repository PSGallery -Force -WarningAction SilentlyContinue
Install-Module -Name MicrosoftPowerBIMgmt -Force -WarningAction SilentlyContinue

Import-Module -Name MicrosoftPowerBIMgmt -WarningAction SilentlyContinue

#Connect to PowerBI Services
Connect-PowerBIServiceAccount

$cpID = $null

#Get the capacity Name as parameter and assign it to a local variable
$cpName = $pcpName

#Get the Capacity ID based on capacity name supplied and assign it to a variable
Try {
$cpID = (Get-PowerBICapacity -Scope Organization | Where-Object { $_.DisplayName -Eq $cpName -and $_.State -Eq "Active" } | Select-Object -ExpandProperty Id).ToString()
}
Catch {
	Write-Error 'The capacity does not exist. This could be because the capacity is not Active or you do not have a capacity administartor permissions.' 
	Exit
}  

#Get the workspace Name as parameter and assign it to a local variable
$wspName = $pwspName

#Create a new workspace using the workspace name
New-PowerBIWorkspace -Name $wspName

#Get the ID of the workspace created and assign it to a variable
$wspID = (Get-PowerBIWorkspace -Name $wspName | Select-Object -ExpandProperty Id).ToString()

#assign the capacity to the workspace
Set-PowerBIWorkspace -Scope Organization -Id $wspID -CapacityId $cpID

