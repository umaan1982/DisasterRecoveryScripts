# Disaster Recovery Scripts

This repository contains a boilerplate Bicep script to create a Disaster Recovery setup on Azure. The setup involves creating a load balancer, virtual machines (VMs) added to the load balancer, a network security group (NSG) assigned to the VMs, and the load balancer added to a Traffic Manager profile.

## Modules

- **LoadBalancer.bicep**: This module is responsible for creating a load balancer.
- **VirutalMachineToLB.bicep**: This module creates virtual machines and adds them to the load balancer.
- **NSGToVirtualMachine.bicep**: This module creates a network security group and assigns it to the virtual machines.
- **LBToTrafficManager.bicep**: This module adds the load balancer to a Traffic Manager profile.
- **main.bicep**: This file contains all of the above module, and are executed through this file.
## Usage

1. Clone the repository:

    ```sh
    git clone https://github.com/umaan1982/DisasterRecoveryScripts.git
    cd DisasterRecoveryScripts
    ```

2. Ensure you have the Azure CLI and Bicep CLI installed.
3. Run the deployment:

    ```sh
    az deployment group create --resource-group <your-resource-group> --template-file main.bicep
    ```

## Disclaimer

This is a boilerplate code and its effectiveness is yet to be tested. Use with caution and ensure to test thoroughly in a non-production environment before deploying to production.

## Contributing

Feel free to fork the repository, make improvements, and submit pull requests.
