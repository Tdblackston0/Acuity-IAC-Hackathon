
metadata name = 'Basic-Deployment'
metadata description = 'This sample deploys a Key Vault with basic settings'
// testing parameters and variables ===========================================================

param region string = resourceGroup().location
param keyVaultName string = 'exampleKV01t${take(uniqueString(resourceGroup().id), 10)}'
param resourceTags object = {
  bu: 'ayi-tech'
  dept: 'ccoe'
  squad: 'enterprise-cloud-services'
}


// testing parameters and variables ===========================================================

// example usage of keyVault template ========================================================

module testDeployment '../../../main.bicep' = {
  name: keyVaultName
  params: {
    keyVaultName: keyVaultName
    resourceTags: resourceTags
    region: region

  }
}
