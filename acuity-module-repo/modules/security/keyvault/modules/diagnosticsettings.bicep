@description('Required. KeyVault Name to create diagnostic settings for')
param keyVaultName string
@description('Required. Diagnostic Settings set name')
param name string
@description('Azure Monitor Workspace Resource ID')
param laWorkspaceId string = ''
@description('The resource Id for the event hub authorization rule')
param eventHubAuthorizationRuleId string = ''
@description('The name of the event hub')
param eventHubName string	= ''
@description('Storage Account Resource ID')
param storageAccountId string = ''
@description('Required. Enable Metric capture')
param captureMetrics bool
@description('Required. Enable Azure Policy Evaluation Details')
param captureAzurePolicyEvaluationDetails bool 
@description('Required. Audit Logs')
param captureAuditLogs bool 


resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: keyVault
  name: name
  properties: {
    workspaceId: empty(laWorkspaceId) ? null : laWorkspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    storageAccountId: empty(storageAccountId) ? null : storageAccountId
    logs: [
      {
        category: 'AuditEvent'
        enabled: captureAuditLogs
        retentionPolicy: {
          days: 0 
          enabled: false
        }
      }
      {
        category: 'AzurePolicyEvaluationDetails'
          enabled: captureAzurePolicyEvaluationDetails
          retentionPolicy: {
              days: 0
              enabled: false
          }
      }
    ] 
    metrics: [
      {
        category: 'AllMetrics'
        enabled: captureMetrics
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
    ]
  }
}
