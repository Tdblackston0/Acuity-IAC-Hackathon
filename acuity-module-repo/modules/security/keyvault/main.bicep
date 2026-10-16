metadata name = 'Keyvault IAC module'
metadata description = 'These modules allow for the deployment of a Keyvault'
metadata owner = 'Enterprise Cloud Services'

import {roleParams} from '../../exports/global.bicep'
import * as kvTypes from 'exports.bicep'

@description('Optional. Location for the KeyVault')
param region string = resourceGroup().location
@description('Required. Name of the KeyVault')
param keyVaultName string
@description('Required. Tags for the KeyVault')
param resourceTags object
@description('Optional. Enable VMs to pull certificates')
param enabledForDeployment bool = false
@description('Optional. Enable VMs to use Keys for Disk Encryption')
param enabledForDiskEncryption bool = false
@description('Optional. Disable Purge Protect, Soft Delete must also be disabled')
param enablePurgeProtection bool = true
@description('Optional. Disable Soft Delete')
param enableSoftDelete bool = true
@description('Optional. Enable Azure Templates to access KeyVault for deployments')
param enabledForTemplateDeployment bool = false
@description('Optional. Set public access to the Storage Account.')
@allowed([
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = 'Enabled'
@description('Optional. Enable Azure IAM based RBAC')
param enableRbacAuthorization bool = true
@description('Optional. Array of Access Policies used if Enable RBAC Authorization is disabled')
param accessPolicies array = []
@description('Optional. Soft Delete Retention In Days')
param softDeleteRetentionInDays int = 7
@description('Optional. Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'
@description('Optional. Key Vault Roles')
param kvRoles roleParams[] = []
@description('Optional. Key Vault Key Roles')
param kvKeyRoles kvTypes.keyRoleParams[] = []
@description('Optional. Key Vault Secret Roles')
param kvSecretRoles kvTypes.secretRoleParams[] = []
@description('Optional. Key Vault Diagnostic Settings')
param kvDiagnostics kvTypes.kvDiagnosticSettings[] = []

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    region: region
    keyVaultName: keyVaultName
    resourceTags: resourceTags
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enablePurgeProtection: enablePurgeProtection
    enableSoftDelete: enableSoftDelete
    enabledForTemplateDeployment: enabledForTemplateDeployment
    publicNetworkAccess: publicNetworkAccess
    enableRbacAuthorization: enableRbacAuthorization
    accessPolicies: accessPolicies
    softDeleteRetentionInDays: softDeleteRetentionInDays
    skuName: skuName
  }
}

module roleassignments 'modules/roleassignments.bicep' = [for kvRole in kvRoles:{
  name: guid( kvRole.entraObjectId, kvRole.roleDefId, keyVaultName)
  params: {
    kvName: keyvault.outputs.keyVaultName
    entraObjectId: kvRole.entraObjectId
    entraObjectType: kvRole.entraObjectType
    roleDefId: kvRole.roleDefId
  }
}]

module keyroleassignment 'modules/keyroleassignments.bicep' = [for kvKeyRole in kvKeyRoles:{
  name: guid( kvKeyRole.entraObjectId, kvKeyRole.roleDefId, kvKeyRole.keyName, keyVaultName)
  params: {
    entraObjectType: kvKeyRole.entraObjectType
    entraObjectId: kvKeyRole.entraObjectId
    roleDefId: kvKeyRole.roleDefId
    kvName: keyvault.outputs.keyVaultName
    keyName: kvKeyRole.keyName
  }
}]

module secretroleassignment 'modules/secretroleassignments.bicep' = [for kvSecretRole in kvSecretRoles: {
  name: guid( kvSecretRole.entraObjectId, kvSecretRole.roleDefId, kvSecretRole.secretName, keyVaultName)
  params: {
    entraObjectType: kvSecretRole.entraObjectType
    entraObjectId: kvSecretRole.entraObjectId
    roleDefId: kvSecretRole.roleDefId
    kvName: keyvault.outputs.keyVaultName
    secretName: kvSecretRole.secretName
  }
}]

module kvdiagnostic 'modules/diagnosticsettings.bicep' = [for kvDiagnostic in kvDiagnostics: {
  name: guid( kvDiagnostic.name, keyVaultName)
  params: {
    keyVaultName: keyvault.outputs.keyVaultName
    name: kvDiagnostic.name
    laWorkspaceId: kvDiagnostic.?laWorkspaceId ?? ''
    eventHubAuthorizationRuleId: kvDiagnostic.?eventHubAuthorizationRuleId ?? ''
    eventHubName: kvDiagnostic.?eventHubName ?? ''
    storageAccountId: kvDiagnostic.?storageAccountId ?? ''
    captureAuditLogs: kvDiagnostic.captureAuditLogs
    captureAzurePolicyEvaluationDetails: kvDiagnostic.captureAzurePolicyEvaluationDetails
    captureMetrics: kvDiagnostic.captureMetrics
    
  }
}]

output keyVaultId string = keyvault.outputs.keyVaultId
output keyVaultName string = keyvault.outputs.keyVaultName
 