param ResourceGroup string = 'resource_group'

resource publicIp1 'Microsoft.Network/publicIPAddresses@2020-08-01' existing = {
  name: 'resource_group_public_ip_1'
  scope: resourceGroup(ResourceGroup)
}

output publicIpAddress1 string = publicIp1.properties.ipAddress

resource publicIp2 'Microsoft.Network/publicIPAddresses@2020-08-01' existing = {
  name: 'resource_group_public_ip_2'
  scope: resourceGroup(ResourceGroup)
}

output publicIpAddress2 string = publicIp2.properties.ipAddress

resource loadbalancer 'Microsoft.Network/loadBalancers@2020-08-01' = {
  name: 'DR-Load-Balancer'
  location: 'West US'
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: concat('Staging-Load-Balancer','-FEIP')
        dependsOn:[ publicIp1]
        properties: {
          publicIPAddress: publicIp1.properties.ipAddress
        }
      }
      {
        name: concat('Staging-Load-Balancer','-FEIP2')
        dependsOn:[ publicIp2]
        properties: {
          publicIPAddress: publicIp2.properties.ipAddress
        }
      }
    ]
    backendAddressPools: [
      {name: concat('Staging-Load-Balancer','-BACKENDPOOL')}
      {name: concat('Staging-Load-Balancer','-BACKENDPOOL2')}
    ]
    loadBalancingRules: [
      {
        name: 'LB_RULE_80'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP'))
          }
          backendAddressPool:{
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-BACKENDPOOL'))
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'DR-Load-Balancer', 'Port_80')
          }
          disableOutboundSnat: true
          idleTimeoutInMinutes: 15
          enableFloatingIP: false
        }
      }
      {
        name: 'LB_RULE_443'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP'))
          }        
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-BACKENDPOOL'))
          }
          protocol: 'Tcp'
          frontendPort: 443
          backendPort: 443
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'DR-Load-Balancer', 'Port_443')
          }
          disableOutboundSnat: true
          idleTimeoutInMinutes: 15
          enableFloatingIP: false
        }
      }
      {
        name: 'LB_RULE_443-PRI1'
        properties: {
          frontendIPConfiguration:{
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP2'))
          }
          backendAddressPool:{
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-BACKENDPOOL2'))
          }
          protocol: 'Tcp'
          frontendPort: 443
          backendPort: 443
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'DR-Load-Balancer', 'Port_443')
          }
          disableOutboundSnat: true
          idleTimeoutInMinutes: 15
          enableFloatingIP: false
        }
      }
      {
        name: 'LB_RULE_80-PRI1'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP2'))
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-BACKENDPOOL2'))
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'DR-Load-Balancer', 'Port_80')
          }
          disableOutboundSnat: true
          idleTimeoutInMinutes: 15
          enableFloatingIP: false
        }
      }
    ]
    inboundNatRules: [
      {
        name: 'RDP-resource1'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP'))
          }
          protocol: 'Tcp'
          frontendPort: 3389
          backendPort: 3389
          enableFloatingIP: true
        }
      }
      {
        name: 'RDP-resource2'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP2'))
          }
          protocol: 'Tcp'
          frontendPort: 3389
          backendPort: 3389
          enableFloatingIP: true
        }
      }
    ]
    outboundRules: [
      {
        name: 'LB-OUTBOUND-RULE'
        properties: {
          protocol: 'Tcp'
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP'))
          }        
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-BACKENDPOOL'))
          }
          allocatedOutboundPorts: 63976
        }
      }
      {
        name: 'LB-OUTBOUND-RULE-PRI1'
        properties: {
          protocol: 'Tcp'
          frontendIPConfiguration:{
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-FEIP2'))
          }
          backendAddressPool:{
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'DR-Load-Balancer', concat('Staging-Load-Balancer','-BACKENDPOOL2'))
          }
          allocatedOutboundPorts: 63976
        }
      }
    ]
  }
}
