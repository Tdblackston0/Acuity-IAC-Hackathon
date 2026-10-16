@export()
type keyRoleParams = {
  @description('Required. Entra ObjectID to Assign Roles')
  entraObjectId: string
  @description('Required. Entra Principal Type to Assign Roles for Cluster')
  entraObjectType: 'ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup'
  @description('Required. Role Definition Id; Key Vault Crypto User or Key Valut Crypto Officer')
  // https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
  roleDefId: '12338af0-0e69-4776-bea7-57ae8d297424' | '14b46e9e-c2b7-41b4-b07b-48a6ebf60603' | 'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  @description('Required. Name of key')
  keyName: string
}

@export()
type secretRoleParams = {
  @description('Required. Entra ObjectID to Assign Roles')
  entraObjectId: string
  @description('Required. Entra Principal Type to Assign Roles for Cluster')
  entraObjectType: 'ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup'
  @description('Required. Role Definition Id; Key Vault Secrets User or Key Vault Secrets Officer')
  // https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
  roleDefId: '4633458b-17de-408a-b874-0445c86b69e6' | 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  @description('Required. Name of secret')
  secretName: string
}

@export()
type kvDiagnosticSettings = {
  @description('Required. Diagnostic Settings set name')
  name: string
  @description('Optional. Log Analytics Monitor Workspace Resource ID')
  laWorkspaceId: string?
  @description('Optional. The resource Id for the event hub authorization rule')
  eventHubAuthorizationRuleId: string?
  @description('Optional. The name of the event hub')
  eventHubName: string?
  @description('Optional. Storage Account Resource ID')
  storageAccountId: string?
  @description('Required. Enable Metric capture')
  captureMetrics: bool
  @description('Required. Enable Azure Policy Evaluation Details Logs')
  captureAzurePolicyEvaluationDetails: bool
  @description('Required. Enable Audit Logs')
  captureAuditLogs: bool
}
