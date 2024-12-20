Param($pcpName,$pwspName,$pkey,$pclientID,$ptenantID,$puserAdmin)


#Get the Key/TenantID and ClientID from the service Principal
$key = $pkey
$ClientID = $pclientID
$SecurePassword = $key | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $ClientID, $SecurePassword
$tenantID = $ptenantID

#Install the required Modules
Install-Module -Name Az -Repository PSGallery -Force -WarningAction SilentlyContinue
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Install-Module -Name MicrosoftPowerBIMgmt -WarningAction SilentlyContinue
Import-Module -Name MicrosoftPowerBIMgmt -WarningAction SilentlyContinue

#Connect to PowerBI Services using the Service Principal
Connect-PowerBIServiceAccount -Tenant $tenantID -ServicePrincipal -Credential $cred -WarningAction SilentlyContinue

$cpID = $null

#Get the capacity Name as parameter and assign it to a local variable
$cpName = $pcpName

#Get the Capacity ID based on capacity name supplied and assign it to a variable
Try {
$cpID = (Get-PowerBICapacity | Where-Object { $_.DisplayName -Eq $cpName -and $_.State -Eq "Active" } | Select-Object -ExpandProperty Id).ToString()
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

#JSON body which contains the capacity ID to be assigned
$body = @{
capacityId = $cpID
}

#Convert the above JSON body to JSON format
$JsonBody = $body | ConvertTo-Json

#REST API URI to assign capacity to a workspace pass the workspaceID to the group
$Uri = 'https://api.powerbi.com/v1.0/myorg/groups/'+$wspID+'/AssignToCapacity'

#Invoke REST API call using powershell cmd
Invoke-PowerBIRestMethod -Url $uri -Method Post -Body $jsonBody

#Get the details of the workspace after assigning the capacity
$wsp = Get-PowerBIWorkspace -Name $wspName

#Write output to screen to verify the Capacity ID
Write-Output $wsp

#JSON body for assigning user to a workspace. Provide the user id and role
$body = @{
  "identifier" = $puserAdmin
  "groupUserAccessRight"= "Admin"
  "principalType"= "User"
}

#Convert the above JSON body to JSON format
$JsonBody = $body | ConvertTo-Json

#REST API URI to assign user to a workspace pass the workspaceID to the group
$Uri = 'https://api.powerbi.com/v1.0/myorg/groups/'+$wspID+'/users'

#Invoke REST API call using powershell cmd
Invoke-PowerBIRestMethod -Url $uri -Method Post -Body $jsonBody

#Get the details of the workspace after assigning the capacity
$wsp = Get-PowerBIWorkspace -Name $wspName

#Write output to screen to verify the Capacity ID
Write-Output $wsp
