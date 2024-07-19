param resourceGroup string = 'Resource-Group'
param location string = 'westus'
param rule1Name string = 'RDP'
param rule2Name string = 'HTTP'
param rule3Name string = 'HTTPS'

resource rule1 'Microsoft.Network/networkSecurityGroups/securityRules@2023-04-01' ={
  name: rule1Name
  properties:{
    description: 'Allow RDP'
    access: 'Allow'
    protocol: 'Tcp'
    direction: 'Inbound'
    priority: 100
    sourceAddressPrefix: 'Internet'
    sourcePortRange: '*'
    destinationAddressPrefix: '*'
    destinationPortRange: 3389
  }
}

resource rule2 'Microsoft.Network/networkSecurityGroups/securityRules@2023-04-01' ={
  name: rule2Name
  properties: {
    description: 'Allow HTTP'
    access: 'Allow'
    protocol: 'Tcp'
    direction: 'Inbound'
    priority: 101
    sourceAddressPrefix: 'Internet'
    sourcePortRange: '*'
    destinationAddressPrefix: '*'
    destinationPortRange: '80'
  }
}

resource rule3 'Microsoft.Network/networkSecurityGroups/securityRules@2023-04-01' ={
  name: rule3Name
  properties: {
    description: 'Allow HTTPS'
    access: 'Allow'
    protocol: 'Tcp'
    direction: 'Inbound'
    priority: 102
    sourceAddressPrefix: 'Internet'
    sourcePortRange: '*'
    destinationAddressPrefix: '*'
    destinationPortRange: '443'
  }
}

resource nsg1 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'Network-Security-Group1'
  location: location
  properties: {
    securityRules: [
      {
        id: resourceId('Microsoft.Network/networkSecurityGroups/securityRules', rgname, 'Network-Security-Group1', 'RDP')
      }
      {
        id: resourceId('Microsoft.Network/networkSecurityGroups/securityRules', rgname, 'Network-Security-Group1', 'HTTP')
      }
      {
        id: resourceId('Microsoft.Network/networkSecurityGroups/securityRules', rgname, 'Network-Security-Group1', 'HTTPS')
      }
    ]
  }
}

resource nsg2 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'Network-Security-Group2'
  location: location
  properties: {
    securityRules: [
      {
        id: resourceId('Microsoft.Network/networkSecurityGroups/securityRules', rgname, 'Network-Security-Group2', 'RDP')
      }
      {
        id: resourceId('Microsoft.Network/networkSecurityGroups/securityRules', rgname, 'Network-Security-Group2', 'HTTP')
      }
      {
        id: resourceId('Microsoft.Network/networkSecurityGroups/securityRules', rgname, 'Network-Security-Group2', 'HTTPS')
      }
    ]
  }
}

resource vmnic1 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: 'VirtualMachine1'
  properties: {
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', rgname, 'Network-Security-Group1')
    }
  }
}

resource vmnic2 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: 'VirtualMachine2'
  properties: {
    networkSecurityGroup:{
      id: resourceId('Microsoft.Network/networkSecurityGroups', rgname, 'Network-Security-Group2')
    }
  }
}
