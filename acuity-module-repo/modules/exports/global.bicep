// Global user-defined types shared across all Acuity Bicep modules.
//
// NOTE: In the upstream Azure DevOps repository
// (https://ablcode.visualstudio.com/Terra/_git/terra-armt-shared-modules)
// this file is the canonical home for cross-module types. It was missing from
// the workshop extract, which broke `az bicep build` on every module that
// imports it. Reconstructed from consumer usage in:
//   modules/security/keyvault/main.bicep
//   modules/security/keyvault/modules/roleassignments.bicep

@export()
type roleParams = {
  @description('Required. Entra ObjectID to Assign Roles')
  entraObjectId: string
  @description('Required. Entra Principal Type to Assign Roles')
  entraObjectType: 'ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup'
  @description('Required. Role Definition Id to assign at the resource scope')
  roleDefId: string
}
