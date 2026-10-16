@description('Required. KeyVault to Assign Roles for Cluster')
param kvName string

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
param roleDefId string

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: roleDefId
}
resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: kvName
}

resource clusterToAcrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid( entraObjectId, roleDefId,keyVault.name)
  scope: keyVault
  properties: {
    description: 'Assign Contributor role for AKS to KeyVault'
    principalId: entraObjectId
    principalType: entraObjectType
    roleDefinitionId: roleDefinition.id
  }
  dependsOn:[
    keyVault
  ]
}
