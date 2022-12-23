param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat', 'prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

az deployment sub create --template-file networking.bicep --parameters envKey=$EnvironmentKey envName=$EnvironmentName --location westeurope