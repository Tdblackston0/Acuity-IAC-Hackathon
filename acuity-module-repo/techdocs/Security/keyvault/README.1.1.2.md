# Keyvault IAC module

A module for creating a Keyvault, assigning permissions, and diagnostic settings.

## Details

This module allows you to deploy or update a Keyvault. This includes:

- Diagnostic settings
- Keyvault role assignments
- Keyvault secret permissions
- Keyvault key permissions

## Parameters

| Name                           | Type     | Required | Description                                                            |
| :----------------------------- | :------: | :------: | :--------------------------------------------------------------------- |
| `keyVaultName`                 | `string` | Yes      | Name of the KeyVault                                                   |
| `resourceTags`                 | `object` | Yes      | Tags for NSG                                                           |
| `enabledForDeployment`         | `bool`   | No       | Enable VMs to pull certificates                                        |
| `enabledForDiskEncryption`     | `bool`   | No       | Enable VMs to use Keys for Disk Encryption                             |
| `enablePurgeProtection`        | `bool`   | No       | Disable Purge Protect, Soft Delete must also be disabled               |
| `enableSoftDelete`             | `bool`   | No       | Disable Soft Delete                                                    |
| `enabledForTemplateDeployment` | `bool`   | No       | Enable Azure Templates to access KeyVault for deployments              |
| `enableRbacAuthorization`      | `bool`   | No       | Enable Azure IAM based RBAC                                            |
| `region`                       | `string` | No       | Location for the KeyVault                                              |
| `accessPolicies`               | `array`  | No       | Array of Access Policies used if Enable RBAC Authorization is disabled |
| `softDeleteRetentionInDays`    | `int`    | No       | Soft Delete Retention In Days                                          |
| `kvRoles`                      | `array`  | Yes      | Key Vault Roles                                                        |
| `kvKeyRoles`                   | `array`  | Yes      | Key Vault Key Roles                                                    |
| `kvSecretRoles`                | `array`  | Yes      | Key Vault Secret Roles                                                 |
| `kvDiagnostics`                | `array`  | Yes      | Key Vault Diagnostic Settings                                          |

## Examples

The parameters and variables used below are for demonstration purposes and are not part of the example. There are more configuration options available than what is shown in the example.

### Example 1

```bicep
// example parameters and variables 
param region string = resourceGroup().location
var keyVaultName = 'exampleKV01t${take(uniqueString(resourceGroup().id), 10)}'
var resourceTags = {
  bu: 'abl-tech'
  dept: 'ccoe'
  squad: 'enterprise-cloud-services'
}

var kvRoles = [
  {
    entraObjectId: '964258d7-d4cc-467f-98a5-7390ad872f21'
    entraObjectType: 'User'
    roleDefId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  }
]

// you could have multiple diagnostic settings structures here
param laWorkspaceId = '/subscriptions/cb051d53-7ccd-4367-86c3-079b57079415/resourceGroups/abl-operations-management-dev/providers/Microsoft.OperationalInsights/workspaces/AcuityBrandsDev'

var kvDiagnostics = [
  {
    name: 'kvDiagnosticSetting'
    laWorkspaceId: laWorkspaceId
  }
]

// example usage of keyVault template 

module keyvault 'shar01acrsy5qa2dvuh.azurecr.io/bicep/terra/security/keyvault:1.1.1' = {
  keyVaultName: keyVaultName
  params: {
    resourceTags: resourceTags
    region: region
    kvDiagnostics: kvDiagnostics
    kvRoles: kvRoles
  }
}
```
