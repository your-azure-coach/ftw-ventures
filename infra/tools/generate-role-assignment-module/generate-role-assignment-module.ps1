# Set variables for the policy initiative and the output file
$policyInitiativeName = "NIST SP 800-53 Rev. 5"
$outputFile = "policyDefinitions.json"

# Get the policy initiative
$policyInitiative = az policy definition show --name $policyInitiativeName

# Extract the policy definition IDs from the policy initiative
$policyDefinitionIds = $policyInitiative.properties.policyDefinitions | ForEach-Object { $_.id }

# Initialize an empty array to store the policy definitions
$policyDefinitions = @()

# Iterate over the policy definition IDs and get the policy definition details
foreach ($policyDefinitionId in $policyDefinitionIds) {
  $policyDefinition = az policy definition show --ids $policyDefinitionId
  $policyDefinitions += $policyDefinition
}

# Convert the policy definitions array to JSON and save it to the output file
$policyDefinitions | ConvertTo-Json | Out-File $outputFile
