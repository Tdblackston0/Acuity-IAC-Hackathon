
metadata name = 'Security-logging'
metadata description = 'This sample deploys a Key Vault with Securities logging policy'
// testing parameters and variables ===========================================================
param region string = resourceGroup().location
param laWorkspaceId string = '/subscriptions/cb051d53-7ccd-4367-86c3-079b57079415/resourceGroups/abl-operations-management-dev/providers/Microsoft.OperationalInsights/workspaces/AcuityBrandsDev'

var keyVaultName = 'exampleKV01t${take(uniqueString(resourceGroup().id), 10)}'
var resourceTags = {
  bu: 'ayi-tech'
  dept: 'ccoe'
  squad: 'enterprise-cloud-services'
}

var kvSecretRoles = [
  {
    entraObjectId: 'dd1c3e4c-91da-4f88-b131-2b1a00071b3e'
    entraObjectType: 'User'
    roleDefId: '4633458b-17de-408a-b874-0445c86b69e6'
    secretName: 'ksg01SecretTest'
  }
]

var kvKeyRoles = [
  {
    entraObjectId: 'dd1c3e4c-91da-4f88-b131-2b1a00071b3e'
    entraObjectType: 'User'
    roleDefId: '12338af0-0e69-4776-bea7-57ae8d297424'
    keyName: 'ksg01KeyTest'
  }
]

var kvRoles = [
  {
    entraObjectId: 'dd1c3e4c-91da-4f88-b131-2b1a00071b3e'
    entraObjectType: 'User'
    roleDefId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  }
]

// you could have multiple diagnostic settings structures here
var kvDiagnostics = [
  {
    name: 'kvDiagnosticSetting'
    laWorkspaceId: laWorkspaceId
    eventHubAuthorizationRuleId: ''
    eventHubName: ''
    storageAccountId: ''
    captureMetrics: false
    captureAzurePolicyEvaluationDetails: true
    captureAuditLogs: true
  }
]


// testing parameters and variables ===========================================================

// example usage of keyVault template ========================================================

module kvDeployment '../../../main.bicep' = {
  name: keyVaultName
  params: {
    keyVaultName: keyVaultName
    resourceTags: resourceTags
    region: region
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enablePurgeProtection: true
    enableSoftDelete: true
    enabledForTemplateDeployment: false
    enableRbacAuthorization: true
    accessPolicies: []
    softDeleteRetentionInDays: 7
    kvDiagnostics: kvDiagnostics
    kvSecretRoles: kvSecretRoles
    kvKeyRoles: kvKeyRoles
    kvRoles: kvRoles
  }
}
