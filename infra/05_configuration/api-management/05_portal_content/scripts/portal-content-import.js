/**
 * This script automates deployments between developer portal instances.
 * In order to run it, you need to:
 * 
 * 1) Clone the api-management-developer-portal repository:
 *    git clone https://github.com/Azure/api-management-developer-portal.git
 * 
 * 2) Install NPM  packages:
 *    npm install
 * 
 * 3) Run this script with a valid combination of arguments:
 *    node ./migrate ^
 *    --sourceSubscriptionId "< your subscription ID >" ^
 *    --sourceResourceGroupName "< your resource group name >" ^
 *    --sourceServiceName "< your service name >" ^
 *    --sourceTenantId "< optional (needed if source and destination is in different subscription) source tenant ID >" ^
 *    --sourceServicePrincipal "< optional (needed if source and destination is in different subscription) source service principal or user name. >" ^
 *    --sourceServicePrincipalSecret "< optional (needed if source and destination is in different subscription) secret or password for service principal or az login for the source apim. >" ^
 *    --destSubscriptionId "< your subscription ID >" ^
 *    --destResourceGroupName "< your resource group name >" ^
 *    --destServiceName "< your service name >"
 *    --destTenantId "< optional (needed if source and destination is in different subscription) destination tenant ID >"
 *    --destServicePrincipal "< optional (needed if source and destination is in different subscription)destination service principal or user name. >"
 *    --destServicePrincipalSecret "< optional (needed if source and destination is in different subscription) secret or password for service principal or az login for the destination. >"
 * 
 * Auto-publishing is not supported for self-hosted versions, so make sure you publish the portal (for example, locally)
 * and upload the generated static files to your hosting after the migration is completed.
 * 
 * You can specify the SAS tokens directly (via sourceToken and destToken), or you can supply an identifier and key,
 * and the script will generate tokens that expire in 1 hour. (via sourceId, sourceKey, destId, destKey)
 */

const { ImporterExporter } = require('./utils.js');

const yargs = require('yargs')
    .example(`node ./migrate ^ \r
    *    --destSubscriptionId "< your subscription ID > \r
    *    --destResourceGroupName "< your resource group name > \r
    *    --destServiceName "< your service name > \r
    *    --snapshotFolder "< folder with portal content > \n`)
    .option('destSubscriptionId', {
        type: 'string',
        description: 'Azure subscription ID.',
        demandOption: true
    })
    .option('destResourceGroupName', {
        type: 'string',
        description: 'Azure resource group name.',
        demandOption: true
    })
    .option('destServiceName', {
        type: 'string',
        description: 'API Management service name.',
        demandOption: true
    })
    .option('snapshotFolder', {
        type: 'string',
        description: 'Folder to export the developer portal snapshot.',
        demandOption: true
    })    
    .help()
    .argv;

async function migrate() {
    try {

        const destImporterExporter = new ImporterExporter(yargs.destSubscriptionId, yargs.destResourceGroupName, yargs.destServiceName, null, null, null, yargs.snapshotFolder);
        await destImporterExporter.cleanup();
        await destImporterExporter.import();
        await destImporterExporter.publish();
    } 
    catch (error) {
        throw new Error(`Unable to import portal content. ${error.message}`);
    }
}

migrate()
    .then(() => {
        console.log("DONE");
        process.exit(0);
    })
    .catch(error => {
        console.error(error.message);
        process.exit(1);
    });