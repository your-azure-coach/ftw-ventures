# TODO List
* Deploy to Azure with credentials
*   IDEA: create a 00_prerequisites for manual actions



* Deploy to Azure without credentials:
  * https://blog.identitydigest.com/azuread-federate-github-actions/
  * https://www.chwe.at/2022/10/github-actions-with-managed-identities/
* Limited role assignment for deployment agent >> private preview
* (N) Generic infra properties / naming
* (N) Governance: array of role assignments
* (N) Configure networking - including DNS and modules with private endpoints
* (N) Extend Web App Landing Zone
  * (N) New Or Existing Container Apps Env
  * (N) Blob and Table
  * (N) Multiple CApps
  * (N) Multiple WApps with App Insights
  * (N) Optional stuff
* Add custom domain to API Management
* Add encryption to App Configuration
* Leverage a Bicep Container Registry
* SQL Serverless and vCore (other tiers: https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore?view=azuresql#service-tiers)