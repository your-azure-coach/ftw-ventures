param(				
    [Parameter(Mandatory=$True)]
    [String]
    $ContainerAppName,

    [Parameter(Mandatory=$True)]
    [String]
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [String]
    $Location,

    [Parameter(Mandatory=$True)]
    [String]
    $EnvironmentId,

    [Parameter(Mandatory=$True)]
    [String]
    $ContainerRegistryName,

    [Parameter(Mandatory=$True)]
    [String]
    $RevisionMode,

    [Parameter(Mandatory=$True)]
    [String]
    $AllowPublicAccess,

    [Parameter(Mandatory=$false)]
    [String]
    $IngressTargetPort = "80"
)

$DefaultContainerName = "main-container"
$DefaultContainerImage = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"

$ErrorActionPreference = "Stop"
Install-Module Az.App -Force

if($null -eq (Get-AzContainerApp -Name $ContainerAppName -ResourceGroupName $ResourceGroupName))
{
    Write-Host "Create new Container App"

    $ContainerTemplate = New-AzContainerAppTemplateObject -Name $DefaultContainerName -Image $DefaultContainerImage -E
    New-AzContainerApp `
        -Name $ContainerAppName `
        -ResourceGroupName $ResourceGroupName `
        -Location $Location `
        -ManagedEnvironmentId $EnvironmentId `
        -TemplateContainer $ContainerTemplate `
        -IdentityType 'SystemAssigned'
}

$ContainerApp = (Get-AzContainerApp -Name $ContainerAppName -ResourceGroupName $ResourceGroupName)
$ContainerRegistry = (Get-AzResource -ResourceGroupName $ResourceGroupName -Name $ContainerRegistryName -ResourceType "Microsoft.ContainerRegistry/registries" )

Write-Host "Grant Container App Identity AcrPull rights on Container Registry"

if($null -eq (Get-AzRoleAssignment -RoleDefinitionName "AcrPull" -ObjectId $ContainerApp.IdentityPrincipalId -Scope $ContainerRegistry.Id))
{
    New-AzRoleAssignment -RoleDefinitionName "AcrPull" -ObjectId $ContainerApp.IdentityPrincipalId -Scope $ContainerRegistry.Id   
}

Write-Host "Update Container App"
    
    $ContainerRegistryCredentialObject = New-AzContainerAppRegistryCredentialObject -Server "${ContainerRegistryName}.azurecr.io" -Identity "system"
    Update-AzContainerApp `
        -Name $ContainerAppName `
        -ResourceGroupName $ResourceGroupName `
        -Location $Location `
        -IngressTargetPort $IngressTargetPort `
        -IngressExternal:([boolean]$AllowPublicAccess) `
        -ConfigurationActiveRevisionsMode $RevisionMode `
        -ConfigurationRegistry $ContainerRegistryCredentialObject

Write-Host "Get Service Principal App Id"

    $token = (Get-AzAccessToken -ResourceUrl https://graph.microsoft.com).Token
    Write-Host "Token"
    Write-Host $token
    $headers = @{'Content-Type' = 'application/json'; 'Authorization' = 'Bearer ' + $token}
    $result = Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($ContainerApp.IdentityPrincipalId)"
    $servicePrincipalAppId = $result.appId

$DeploymentScriptResult = @{}
$DeploymentScriptResult['principalId'] = $ContainerApp.IdentityPrincipalId
$DeploymentScriptResult['principalAppId'] = $servicePrincipalAppId

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['result'] =  $DeploymentScriptResult