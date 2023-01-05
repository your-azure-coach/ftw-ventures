param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName,

    [Parameter(Mandatory)]
    [string]$ApiVersion,

    [Parameter(Mandatory)]
    [string]$ApiDefinitionUrl
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file hotel-booking-api.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName version=$ApiVersion definitionUrl=$ApiDefinitionUrl --location westeurope --name "hotels-api_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"