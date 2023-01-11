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
 */

const { ImporterExporter } = require('./utils.js');

const yargs = require('yargs')
    .example(`node ./migrate ^ \r
    *    --sourceSubscriptionId "< your subscription ID > \r
    *    --sourceResourceGroupName "< your resource group name > \r
    * *  --sourceServiceName "< your service name > \r
    *    --snapshotFolder "< your snapshot folder path > \n`)
    .option('sourceSubscriptionId', {
        type: 'string',
        description: 'Azure subscription ID.',
        demandOption: true
    })
    .option('sourceResourceGroupName', {
        type: 'string',
        description: 'Azure resource group name.',
        demandOption: true
    })
    .option('sourceServiceName', {
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
        const sourceImporterExporter = new ImporterExporter(yargs.sourceSubscriptionId, yargs.sourceResourceGroupName, yargs.sourceServiceName, null, null, null, yargs.snapshotFolder);
        await sourceImporterExporter.export();
    } 
    catch (error) {
        throw new Error(`Unable to export portal content. ${error.message}`);
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