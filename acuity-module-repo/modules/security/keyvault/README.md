# Keyvault IAC module `[Security/Keyvault]`

These modules allow for the deployment of a Keyvault

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2020-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2021-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:shar01acrsy5qa2dvuh.azurecr.io/bicep/terra/security/keyvault:<version>`.

- [Basic-Deployment](#example-1-basic-deployment)
- [Security-logging](#example-2-security-logging)

### Example 1: _Basic-Deployment_

This sample deploys a Key Vault with basic settings

<details>

<summary>via Bicep module</summary>

```bicep
module keyvault 'br:shar01acrsy5qa2dvuh.azurecr.io/bicep/terra/security/keyvault:<version>' = {
  name: 'keyvaultDeployment'
  params: {
    // Required parameters
    keyVaultName: '<keyVaultName>'
    resourceTags: '<resourceTags>'
    // Non-required parameters
    region: '<region>'
  }
}
```

</details>
<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "resourceTags": {
      "value": "<resourceTags>"
    },
    // Non-required parameters
    "region": {
      "value": "<region>"
    }
  }
}
```

</details>
<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br:shar01acrsy5qa2dvuh.azurecr.io/bicep/terra/security/keyvault:<version>'

// Required parameters
param keyVaultName = '<keyVaultName>'
param resourceTags = '<resourceTags>'
// Non-required parameters
param region = '<region>'
```

</details>

### Example 2: _Security-logging_

This sample deploys a Key Vault with Securities logging policy

<details>

<summary>via Bicep module</summary>

```bicep

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
```

</details>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | Name of the KeyVault |
| [`resourceTags`](#parameter-resourcetags) | object | Tags for the KeyVault |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicies`](#parameter-accesspolicies) | array | Array of Access Policies used if Enable RBAC Authorization is disabled |
| [`enabledForDeployment`](#parameter-enabledfordeployment) | bool | Enable VMs to pull certificates |
| [`enabledForDiskEncryption`](#parameter-enabledfordiskencryption) | bool | Enable VMs to use Keys for Disk Encryption |
| [`enabledForTemplateDeployment`](#parameter-enabledfortemplatedeployment) | bool | Enable Azure Templates to access KeyVault for deployments |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Disable Purge Protect, Soft Delete must also be disabled |
| [`enableRbacAuthorization`](#parameter-enablerbacauthorization) | bool | Enable Azure IAM based RBAC |
| [`enableSoftDelete`](#parameter-enablesoftdelete) | bool | Disable Soft Delete |
| [`kvDiagnostics`](#parameter-kvdiagnostics) | array | Key Vault Diagnostic Settings |
| [`kvKeyRoles`](#parameter-kvkeyroles) | array | Key Vault Key Roles |
| [`kvRoles`](#parameter-kvroles) | array | Key Vault Roles |
| [`kvSecretRoles`](#parameter-kvsecretroles) | array | Key Vault Secret Roles |
| [`region`](#parameter-region) | string | Location for the KeyVault |
| [`skuName`](#parameter-skuname) | string | Specifies whether the key vault is a standard vault or a premium vault. |
| [`softDeleteRetentionInDays`](#parameter-softdeleteretentionindays) | int | Soft Delete Retention In Days |

### Parameter: `keyVaultName`

Name of the KeyVault

- Required: Yes
- Type: string

### Parameter: `resourceTags`

Tags for the KeyVault

- Required: Yes
- Type: object

### Parameter: `accessPolicies`

Array of Access Policies used if Enable RBAC Authorization is disabled

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enabledForDeployment`

Enable VMs to pull certificates

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enabledForDiskEncryption`

Enable VMs to use Keys for Disk Encryption

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enabledForTemplateDeployment`

Enable Azure Templates to access KeyVault for deployments

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePurgeProtection`

Disable Purge Protect, Soft Delete must also be disabled

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableRbacAuthorization`

Enable Azure IAM based RBAC

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableSoftDelete`

Disable Soft Delete

- Required: No
- Type: bool
- Default: `True`

### Parameter: `kvDiagnostics`

Key Vault Diagnostic Settings

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`captureAuditLogs`](#parameter-kvdiagnosticscaptureauditlogs) | bool | Enable Audit Logs |
| [`captureAzurePolicyEvaluationDetails`](#parameter-kvdiagnosticscaptureazurepolicyevaluationdetails) | bool | Enable Azure Policy Evaluation Details Logs |
| [`captureMetrics`](#parameter-kvdiagnosticscapturemetrics) | bool | Enable Metric capture |
| [`name`](#parameter-kvdiagnosticsname) | string | Diagnostic Settings set name |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleId`](#parameter-kvdiagnosticseventhubauthorizationruleid) | string | The resource Id for the event hub authorization rule |
| [`eventHubName`](#parameter-kvdiagnosticseventhubname) | string | The name of the event hub |
| [`laWorkspaceId`](#parameter-kvdiagnosticslaworkspaceid) | string | Log Analytics Monitor Workspace Resource ID |
| [`storageAccountId`](#parameter-kvdiagnosticsstorageaccountid) | string | Storage Account Resource ID |

### Parameter: `kvDiagnostics.captureAuditLogs`

Enable Audit Logs

- Required: Yes
- Type: bool

### Parameter: `kvDiagnostics.captureAzurePolicyEvaluationDetails`

Enable Azure Policy Evaluation Details Logs

- Required: Yes
- Type: bool

### Parameter: `kvDiagnostics.captureMetrics`

Enable Metric capture

- Required: Yes
- Type: bool

### Parameter: `kvDiagnostics.name`

Diagnostic Settings set name

- Required: Yes
- Type: string

### Parameter: `kvDiagnostics.eventHubAuthorizationRuleId`

The resource Id for the event hub authorization rule

- Required: No
- Type: string

### Parameter: `kvDiagnostics.eventHubName`

The name of the event hub

- Required: No
- Type: string

### Parameter: `kvDiagnostics.laWorkspaceId`

Log Analytics Monitor Workspace Resource ID

- Required: No
- Type: string

### Parameter: `kvDiagnostics.storageAccountId`

Storage Account Resource ID

- Required: No
- Type: string

### Parameter: `kvKeyRoles`

Key Vault Key Roles

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`entraObjectId`](#parameter-kvkeyrolesentraobjectid) | string | Entra ObjectID to Assign Roles |
| [`entraObjectType`](#parameter-kvkeyrolesentraobjecttype) | string | Entra Principal Type to Assign Roles for Cluster |
| [`keyName`](#parameter-kvkeyroleskeyname) | string | Name of key |
| [`roleDefId`](#parameter-kvkeyrolesroledefid) | string | Role Definition Id; Key Vault Crypto User or Key Valut Crypto Officer |

### Parameter: `kvKeyRoles.entraObjectId`

Entra ObjectID to Assign Roles

- Required: Yes
- Type: string

### Parameter: `kvKeyRoles.entraObjectType`

Entra Principal Type to Assign Roles for Cluster

- Required: Yes
- Type: string
- Allowed:

  ```bicep
  [
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `kvKeyRoles.keyName`

Name of key

- Required: Yes
- Type: string

### Parameter: `kvKeyRoles.roleDefId`

Role Definition Id; Key Vault Crypto User or Key Valut Crypto Officer

- Required: Yes
- Type: string
- Allowed:

  ```bicep
  [
    '12338af0-0e69-4776-bea7-57ae8d297424'
    '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
    'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  ]
  ```

### Parameter: `kvRoles`

Key Vault Roles

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`entraObjectId`](#parameter-kvrolesentraobjectid) | string | Entra ObjectID to Assign Roles |
| [`entraObjectType`](#parameter-kvrolesentraobjecttype) | string | Entra Object Type to Assign Roles |
| [`roleDefId`](#parameter-kvrolesroledefid) | string | Role Definition Id |

### Parameter: `kvRoles.entraObjectId`

Entra ObjectID to Assign Roles

- Required: Yes
- Type: string

### Parameter: `kvRoles.entraObjectType`

Entra Object Type to Assign Roles

- Required: Yes
- Type: string
- Allowed:

  ```bicep
  [
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `kvRoles.roleDefId`

Role Definition Id

- Required: Yes
- Type: string

### Parameter: `kvSecretRoles`

Key Vault Secret Roles

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`entraObjectId`](#parameter-kvsecretrolesentraobjectid) | string | Entra ObjectID to Assign Roles |
| [`entraObjectType`](#parameter-kvsecretrolesentraobjecttype) | string | Entra Principal Type to Assign Roles for Cluster |
| [`roleDefId`](#parameter-kvsecretrolesroledefid) | string | Role Definition Id; Key Vault Secrets User or Key Vault Secrets Officer |
| [`secretName`](#parameter-kvsecretrolessecretname) | string | Name of secret |

### Parameter: `kvSecretRoles.entraObjectId`

Entra ObjectID to Assign Roles

- Required: Yes
- Type: string

### Parameter: `kvSecretRoles.entraObjectType`

Entra Principal Type to Assign Roles for Cluster

- Required: Yes
- Type: string
- Allowed:

  ```bicep
  [
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `kvSecretRoles.roleDefId`

Role Definition Id; Key Vault Secrets User or Key Vault Secrets Officer

- Required: Yes
- Type: string
- Allowed:

  ```bicep
  [
    '4633458b-17de-408a-b874-0445c86b69e6'
    'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  ]
  ```

### Parameter: `kvSecretRoles.secretName`

Name of secret

- Required: Yes
- Type: string

### Parameter: `region`

Location for the KeyVault

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `skuName`

Specifies whether the key vault is a standard vault or a premium vault.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:

  ```bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `softDeleteRetentionInDays`

Soft Delete Retention In Days

- Required: No
- Type: int
- Default: `7`

## Outputs

| Output | Type |
| :-- | :-- |
| `keyVaultId` | string |
| `keyVaultName` | string |
