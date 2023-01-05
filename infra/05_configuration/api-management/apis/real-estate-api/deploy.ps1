param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName,

    [Parameter(Mandatory)]
    [string]$ApiVersion
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file real-estate-api.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName version=$ApiVersion --location westeurope --name "apim_real-estate-api_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"