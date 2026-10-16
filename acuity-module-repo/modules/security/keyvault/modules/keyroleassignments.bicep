@description('Required. KeyVault to Assign Roles for Cluster')
param kvName string

@description('Required. Name of key')
param keyName string

@description('Required. Entra ObjectID to Assign Roles')
param entraObjectId string

@description('Required. Object Type to Assign Roles')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
])
param entraObjectType string

@description('Required. Role Definition Id to Assign Roles for Cluster')
@allowed([
  'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  '12338af0-0e69-4776-bea7-57ae8d297424'
  '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
])
param roleDefId string


resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: roleDefId
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: kvName
}

resource key 'Microsoft.KeyVault/vaults/keys@2022-07-01' existing = {
  parent: keyVault
  name: keyName
}

resource clusterToAcrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid( entraObjectId, roleDefId,keyVault.name)
  scope: key
  properties: {
    description: 'Assign Contributor role for AKS to KeyVault'
    principalId: entraObjectId
    principalType: entraObjectType
    roleDefinitionId: roleDefinition.id
  }
  dependsOn:[
    key
  ]
}
