// -------------------------------------------------------
// Phase 1: Resource Group + Azure Container Registry
// Deployment scope: Subscription
// -------------------------------------------------------
targetScope = 'subscription'

@description('デプロイ先のリージョン')
param location string = 'eastus'

@description('環境名 (dev, stg, prod)')
@allowed(['dev', 'stg', 'prod'])
param environment string = 'dev'

@description('ワークロード名')
param workloadName string = 'ghasdefender'

// Azure CAF 命名規則に準拠
var resourceGroupName = 'rg-${workloadName}-${environment}-${location}'
var tags = {
  environment: environment
  workload: workloadName
  managedBy: 'bicep'
}

// -------------------------------------------------------
// Resource Group
// -------------------------------------------------------
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// -------------------------------------------------------
// ACR Module (Resource Group scope)
// -------------------------------------------------------
module acr 'modules/acr.bicep' = {
  name: 'deploy-acr'
  scope: rg
  params: {
    location: location
    environment: environment
    workloadName: workloadName
    tags: tags
  }
}

// -------------------------------------------------------
// Outputs
// -------------------------------------------------------
output resourceGroupName string = rg.name
output acrName string = acr.outputs.acrName
output acrLoginServer string = acr.outputs.acrLoginServer
