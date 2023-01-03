param (
    [Parameter(Mandatory)]
    [string]$EnvironmentName,

    [Parameter(Mandatory)]
    [string]$ApiVersion,

    [Parameter(Mandatory)]
    [string]$ApiDefinitionUrl
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file hotels-api.bicep --parameters envName=$EnvironmentName version=$ApiVersion definitionUrl=$ApiDefinitionUrl --location westeurope --name "hotels-api_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"