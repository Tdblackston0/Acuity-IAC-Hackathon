@description('Required. Location for the KeyVault')
param region string
@description('Required. Name of the KeyVault')
param keyVaultName string
@description('Required. Tags for KeyVault')
param resourceTags object
@description('Required. Enable VMs to pull certificates')
param enabledForDeployment bool
@description('Required. Enable VMs to use Keys for Disk Encryption')
param enabledForDiskEncryption bool
@description('Required. Disable Purge Protect, Soft Delete must also be disabled')
param enablePurgeProtection bool
@description('Required. Disable Soft Delete')
param enableSoftDelete bool
@description('Required. Enable Azure Templates to access KeyVault for deployments')
param enabledForTemplateDeployment bool
@description('Optional. Set public access to the Storage Account.')
@allowed([
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = 'Enabled'
@description('Required. Enable Azure IAM based RBAC')
param enableRbacAuthorization bool
@description('Required. Array of Access Policies used if Enable RBAC Authorization is disabled')
param accessPolicies array
@description('Required. Soft Delete Retention In Days')
param softDeleteRetentionInDays int
@description('Required. Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  location: region
  name: keyVaultName
  tags: resourceTags
  properties:{
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enablePurgeProtection: enablePurgeProtection || enableSoftDelete
    enableSoftDelete: enableSoftDelete
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableRbacAuthorization: enableRbacAuthorization
    publicNetworkAccess: publicNetworkAccess
    createMode: 'default' //Creating or updating the key vault (not recovering)
    sku: {
      family: 'A'
      name: skuName
    }
    softDeleteRetentionInDays: softDeleteRetentionInDays
    tenantId: subscription().tenantId
    accessPolicies: enableRbacAuthorization ? [] : accessPolicies
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
