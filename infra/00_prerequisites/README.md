# Prerequisites

Before we can automate the complete deployment, some prerequisites have to be requested or created manually.  This README contains an overview.

## Subscriptions

We assume that the subscriptions are already pre-configured.

## GitHub

We assume that a GitHub repository is available.
Execute the folowing steps for every environment.  A user with *Owner* permissions on the subscription is needed.

### Create Managed Identity

We use user-assigned managed identity for executing deployments from within GitHub.  The main reason is the fact that we don't need to handle secrets that will expire one day, thanks to *Federated Credentials*.  Next to that, we can reuse this identity for the *DeploymentScripts* within Bicep.

This is how you can configure it:

* Create a resource group for every environment in the correct subscription: `ftw-<env>-shared-devops-rg`

* In the resource group, create a User-Assigned Managed Identity: `ftw-<env>-devops-identity`

* In the *Federated credentials* tab, click `+ Add Credential` and choose the GitHub Actions scenario:
  * Connect your GitHub account:
    * **Organization:** your-azure-coach
    * **Repository:** ftw-ventures
    * **Entity:** Environment
    * **Environment:** dev
  * Credential details:
    * **Name:** `ftw-github-runner-<env>`

### Assign Azure Permissions

The managed identity must have sufficient permissions to deploy.  Grant the following permissions on subscription level:

* **Contributor:** required to create all Azure resources
* **User Access Administrator:** required to perform role assignments

### Configure GitHub Credentials

Execute the following steps in the GitHub repository:

* Create a new environment, in the *Settings* section of your GitHub repo: `<env>`

* Add the following environment secrets in the created environment:
  * **AZURE_CLIENT_ID:** the Client ID of the managed identity
  * **AZURE_TENANT_ID:** the Azure AD tenant ID
  * **AZURE_SUBSCRIPTION_ID:** the ID of the appropriate subscription

### Permissions on Microsoft Graph

The identity needs to query the Azure AD applications, via the Microsoft Graph.  Assign the **Application.Read.All** permission to the identity with PowerShell, as described in [this blog](https://www.inthecloud247.com/configure-a-user-assigned-managed-identity-the-basics/).

### Permissions on SQL

In order to allow the GitHub Runner to create external users in Azure SQL Datbase, you must ensure that the managed identity `ftw-<env>-devops-identity` is part of the Azure AD Group that is assigned as Azure Administrator.

## API Management Portal App Registration

* Create an App Registration, named `FTW-<ENV>-APIM-PORTAL-APPR`, according to [this procedure](https://mscloud.be/azure/Enable-AzureAD-for-APIM-portal/).

* Grant the [following access](https://learn.microsoft.com/en-ca/azure/api-management/api-management-howto-aad#add-an-external-azure-ad-group) access to the App Registration

* In the `ftw-<env>-shared-devops-rg` resource group, create a Key Vault with the name `ftw-<env>-devops-kv`.

* Add the following secrets:
  * APIM--PORTAL--AAD--CLIENT--ID: client id of the created App Registration - with expiry date
  * APIM--PORTAL--AAD--CLIENT--SECRET: secret of the created App Registration - with expiry date

* Grant the managed identity `ftw-<env>-devops-identity` the Key Vault Secrets User role on the Key Vault 

* Allows Azure Resource Manager for template deployment