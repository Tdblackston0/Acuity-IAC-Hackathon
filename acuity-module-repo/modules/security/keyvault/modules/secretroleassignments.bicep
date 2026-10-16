@description('Required. KeyVault to Assign Roles')
param kvName string

@description('Required. Name of secret')
param secretName string

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
  '4633458b-17de-408a-b874-0445c86b69e6'
  'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
])
param roleDefId string


resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: roleDefId
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: kvName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' existing = {
  parent: keyVault
  name: secretName
}

resource clusterToAcrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid( entraObjectId, roleDefId,keyVault.name)
  scope: secret
  properties: {
    description: 'Assign Contributor role for AKS to KeyVault'
    principalId: entraObjectId
    principalType: entraObjectType
    roleDefinitionId: roleDefinition.id
  }
  dependsOn:[
    secret
  ]
}
