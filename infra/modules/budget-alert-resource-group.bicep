// Scope
targetScope = 'resourceGroup'

// Parameters
param name string
param emailAddresses string
param budget int
param startDate string ='2022-11-01' // Needs to be the first day - budget alert startdate cannot change

@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
])
param timeGrain string = 'Monthly'

// Define resources
resource budgetAlert 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: name
  scope: resourceGroup()
  properties: {
    amount: budget
    category: 'Cost'
    notifications: {
      Notification_ExceededActualBudget: {
        thresholdType: 'Actual'
        operator: 'GreaterThan'
        threshold: 100
        contactEmails: split(emailAddresses, ';')
        enabled: true
      }
      Notification_ExceededForecastedBudget: {
        thresholdType: 'Forecasted'
        operator: 'GreaterThan'
        threshold: 100
        contactEmails: split(emailAddresses, ';')
        enabled: true
      }}
    timeGrain: timeGrain
    timePeriod: {
      startDate: startDate
    }
  }
}
