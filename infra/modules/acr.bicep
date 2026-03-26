// -------------------------------------------------------
// Azure Container Registry
// -------------------------------------------------------

@description('デプロイ先のリージョン')
param location string

@description('環境名')
param environment string

@description('ワークロード名')
param workloadName string

@description('リソースタグ')
param tags object

// Azure CAF 命名規則: ACR は英数字のみ (ハイフン不可)
var acrName = 'cr${workloadName}${environment}'

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
output acrId string = acr.id
