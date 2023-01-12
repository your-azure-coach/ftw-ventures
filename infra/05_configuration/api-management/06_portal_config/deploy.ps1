param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file portal-config.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope --name "apim_portal_config_$((Get-Date).ToString("yyyyMMdd_HHmmss"))"