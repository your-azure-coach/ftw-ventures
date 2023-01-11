param (
    [Parameter(Mandatory)]
    [ValidateSet('dev', 'tst', 'uat','prd')]
    [string]$EnvironmentKey,

    [Parameter(Mandatory)]
    [string]$EnvironmentName
)

$ErrorActionPreference = "Stop"

cd scripts
npm install
# Need to redesign to ensure that these values are retrieved dynamically from the shared infra
node ./portal-content-import --destSubscriptionId "99da81c1-72ed-4a56-8c96-f360dbd22610" --destResourceGroupName "ftw-$($EnvironmentName)-shared-infrastructure-rg" --destServiceName "ftw-$($EnvironmentName)-api-mgmt-apim" --snapshotFolder "../content"
Remove-Item 'node_modules' -Force -Recurse
cd..