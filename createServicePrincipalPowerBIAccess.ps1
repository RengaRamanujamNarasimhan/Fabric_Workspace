Param($pservicePrincipal)

Install-Module -Name Az -Repository PSGallery -Force -WarningAction SilentlyContinue
Import-Module Az.Resources -Force

#Create a Service Principal for login access
$sp = New-AzADServicePrincipal -DisplayName $pservicePrincipal

Write-Host "Service Principal Created:"
	  
#PowerBI Capacity.Read.All
Add-AzADAppPermission -PermissionId '76e2ebd5-0dfb-4a5b-93c7-ed89e0362834' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000'

#PowerBI Capacity.ReadWrite.All
Add-AzADAppPermission -PermissionId '4eabc3d1-b762-40ff-9da5-0e18fdf11230' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000'

#PowerBI Workspace.Read.All
Add-AzADAppPermission -PermissionId 'b2f1b2fa-f35c-407c-979c-a858a808ba85' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000'

#PowerBI Workspace.ReadWrite.All
Add-AzADAppPermission -PermissionId '445002fb-a6f2-4dc1-a81e-4254a111cd29' -ApplicationId $sp.AppID -ApiId '00000009-0000-0000-c000-000000000000'

#Graph User.Read.All
Add-AzADAppPermission -PermissionId 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' -ApplicationId $sp.AppID -ApiId '00000003-0000-0000-c000-000000000000'

Write-Host "Service Principal Permissions applied"
Write-Output $sp.ID
