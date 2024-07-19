module createLoadBalancer 'LoadBalancer.bicep' = {
    name:'deploy-loadbalancer'
}

module VirtualMachineToLoadBalancer 'VirutalMachineToLB.bicep' = {
    name: 'deploy-vm-to-loadbalancer'
}

module NetworkSecurityGroupToVM 'NSGToVirtualMachine.bicep' = {
    name: 'deploy-nsg-to-virtualmachine'
}

module LoadBalancerToTrafficManager 'LBToTrafficManager.bicep' = {
    name: 'deploy-lb-to-trafficmanager'
}