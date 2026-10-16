# Keyvault IAC module

These modules allow for the deployment of a Keyvault

## Details

{{Add detailed information about the module}}

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

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```