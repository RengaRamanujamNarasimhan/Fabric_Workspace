Param($pservicePrincipal)

Connect-AzAccount -UseDeviceAuthentication

#Create a Service Principal for login access
$sp = New-AzADServicePrincipal -DisplayName $pservicePrincipal

Write-Host "Service Principal Created"

#######################################################################
####Provide below API Permission to access the PowerBI Services    ####
##These permissions are required for the service Principal to        ##
#        Connect to PowerBI workspace using Service Principal		  # 
#		 Fetch the Fabric Capacity available						  # 
#		 Create a workspace in the Fabric Platform				      #
#		 Assign user access to workspace using ServicePrincipal       #
#######################################################################
	  
#PowerBI Capacity.ReadWrite.All
Add-AzADAppPermission -PermissionId '4eabc3d1-b762-40ff-9da5-0e18fdf11230' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000' -Type 'Scope'

#PowerBI Workspace.ReadWrite.All
Add-AzADAppPermission -PermissionId '445002fb-a6f2-4dc1-a81e-4254a111cd29' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000' -Type 'Scope'

#PowerBI App.Read.All
Add-AzADAppPermission -PermissionId '8b01a991-5a5a-47f8-91a2-84d6bfd72c02' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000' -Type 'Scope'

#PowerBI Tenant.Read.All Application
Add-AzADAppPermission -PermissionId '654b31ae-d941-4e22-8798-7add8fdf049f' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000' -Type 'Role'

#PowerBI Tenant.ReadWrite.All Application
Add-AzADAppPermission -PermissionId '28379fa9-8596-4fd9-869e-cb60a93b5d84' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000' -Type 'Role'

#Graph User.Read.All
Add-AzADAppPermission -PermissionId 'a154be20-db9c-4678-8ab7-66f6cc099a59' -ApplicationId $sp.AppID -ApiId '00000003-0000-0000-c000-000000000000' -Type 'Scope'

#Graph Directory.ReadWrite.All Application
Add-AzADAppPermission -PermissionId '19dbc75e-c2e2-444c-a770-ec69d8559fc7' -ApplicationId $sp.AppID -ApiId '00000003-0000-0000-c000-000000000000' -Type 'Role'

Write-Host "Service Principal Permissions applied:"
Get-AzADAppPermission -ApplicationId $sp.AppId

#Service Principal ID to be provided as an input for the Workspace creation while registering for Fabric
Write-Output $sp.ID 

#Get the Secret key to be provided as an input for the Workspace creation while registering for Fabric
$sp.PasswordCredentials.SecretText

#Get the Client ID to be provided as an input for the Workspace creation while registering for Fabric
$sp.AppId

#################################################################################################

#######       Key Notes: Other activities to be done in Azure Portal as follows  		  #######

#Open the above created Service Princial in Azure Portal App Registration
#Go to Api Permission and Provide Grant Admin Consent to permissions applied
#Go to Expose an API and Add application URI
#Create a New Security Group and add the Service Principal as an Owner and Member in that Group
#Assign the Security group with Owner permission for the resource group in which fabric will be deployed
#########################################################################################################
