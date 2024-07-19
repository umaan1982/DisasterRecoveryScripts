param ResourceGroup string = 'resource_group'
@description('The resource group where the public IP addresses exist.')

resource publicIp1 'Microsoft.Network/publicIPAddresses@2020-08-01' existing = {
  name: 'resource_group_public_ip_1'
  scope: resourceGroup(ResourceGroup)
}
@description('Exposing the public Ip of the publicIpAddress1 and publicIpAddress2')
output publicIpAddress1 string = publicIp1.properties.ipAddress

resource publicIp2 'Microsoft.Network/publicIPAddresses@2020-08-01' existing = {
  name: 'resource_group_public_ip_2'
  scope: resourceGroup(ResourceGroup)
}
output publicIpAddress2 string = publicIp2.properties.ipAddress

@description('Createing the traffic manager,the DNS name of the Traffic Manager should be kept unique')

resource trafficManager 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: 'loadbalancer_name'
  location: 'global'
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/'
      expectedStatusCodeRanges: [
        {
          min: 200
          max: 202
        }
        {
          min: 301
          max: 302
        }
      ]
    }
    endpoints: [
      {
        type: 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints'
        name: 'endpoint1'
        properties: {
          target: publicIp1.properties.ipAddress
          endpointStatus: 'Enabled'
        }
      }
      {
        type: 'Microsoft.Network/TrafficManagerProfiles/ExternalEndpoints'
        name: 'endpoint2'
        properties: {
          target: publicIp2.properties.ipAddress
          endpointStatus: 'Enabled'
        }
      }
    ]
  }

output TrafficManagerDNS string = trafficManager.properties.dnsConfig.relativeName

@description('As this resource might reference an existing Azure endpoint, we would be disabling it.')
@description('The endpoint we are disabling here exists in the same resource group as the Traffic Manager.')


resource existingEndpoint 'Microsoft.Network/trafficmanagerprofiles/AzureEndpoints@2022-04-01' = {
  name: 'name_of_trafficManager_endpoint'
  parent: trafficManager
  properties: {
    endpointStatus: 'Disabled'
  }
}
