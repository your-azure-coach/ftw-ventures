$bicepTemplatePath = "./role-assignment-template.txt"
$bicepTemplateOutputPath = "./role-assignment.bicep"

#Retrieve all the standard and custom roles.
$roles = (az role definition list --query "[].{Name:roleName,Id:name}" | ConvertFrom-Json) | Sort-Object -Property Name

#Get the content of the template that contains allowedRoles and roleIdMapping placeholders
$bicepTemplateContent = Get-Content -Path $bicepTemplatePath

#Loop and compose the allowedRoles and roleIdMapping placeholders in the desired format
$allowedRolesStringBuilder = New-Object System.Text.StringBuilder
$roleIdMappingStringBuilder = New-Object System.Text.StringBuilder

foreach ($role in $roles) {
    $allowedRolesStringBuilder.AppendLine("'$($role.Name)'")
    $roleIdMappingStringBuilder.AppendLine("'$($role.Name)': resourceId('Microsoft.Authorization/roleAssignments', '$($role.Id)')")
}

#Replace the palce holders
$bicepTemplateContent = $bicepTemplateContent -replace "{{allowedRoles}}", $allowedRolesStringBuilder.ToString()
$bicepTemplateContent = $bicepTemplateContent -replace "{{roleIdMapping}}", $roleIdMappingStringBuilder.ToString()

#Export the resulting bicep module
Set-Content -Path $bicepTemplateOutputPath -Value $bicepTemplateContent -Force