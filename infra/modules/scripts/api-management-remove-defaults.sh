az apim api delete --service-name $API_MANAGEMENT_NAME --resource-group $RESOURCE_GROUP_NAME --api-id 'echo-api' --yes;
az apim product delete --service-name $API_MANAGEMENT_NAME --resource-group $RESOURCE_GROUP_NAME --product-id 'starter' --delete-subscriptions true --yes;
az apim product delete --service-name $API_MANAGEMENT_NAME --resource-group $RESOURCE_GROUP_NAME --product-id 'unlimited' --delete-subscriptions true --yes;
echo '{"result": {} }' > $AZ_SCRIPTS_OUTPUT_PATH