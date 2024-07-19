param resourceGroup  string = 'Resource-Group'
param loadBalancer string = 'DR-Load-Balancer'
param backendPool1 string = 'LoadBalancer-BackendPool1'
param backendPool2 string = 'LoadBalancer-BackendPool2'
param vmNIC1 string = 'Network-Interface-1'
param vmNIC2 string = 'Network-Interface-2'

resource nic1 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: vmNIC1
  properties: {
    ipConfigurations:[
      {
        loadBalancerBackendAddressPools: [
          {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', rg, lbname, backendPool1)
          }
        ]
      }
    ]
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: vmNIC2
  properties: {
    ipConfigurations:[
      {
        loadBalancerBackendAddressPools: [
          {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', rg, lbname, backendPool2)
          }
        ]
      }
    ]
  }
}

