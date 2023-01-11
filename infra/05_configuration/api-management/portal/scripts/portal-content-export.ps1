npm install
node ./portal-content-export --sourceSubscriptionId "99da81c1-72ed-4a56-8c96-f360dbd22610" --sourceResourceGroupName "ftw-dev-shared-infrastructure-rg" --sourceServiceName "ftw-dev-api-mgmt-apim" --snapshotFolder "../content"
Remove-Item 'node_modules' -Force -Recurse