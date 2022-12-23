az config set extension.use_dynamic_install=yes_without_prompt;
result=$(az containerapp show --resource-group $RESOURCE_GROUP_NAME --name $CONTAINER_APP_NAME --query "properties");
echo $result
if [ -z "$result" ]; then
    echo '{"result": { "properties" : {}}}' > $AZ_SCRIPTS_OUTPUT_PATH
else
    echo $result | jq -c '{result: {properties: .}}' > $AZ_SCRIPTS_OUTPUT_PATH
fi
