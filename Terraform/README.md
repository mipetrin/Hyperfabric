# Hyperfabric
Example Terraform plan for interaction with Cisco Hyperfabric
################################################################################

Example crafted by Michael Petrinovic (mipetrin@cisco.com), 2025

Based off the Hyperfabric documentation available at the Cisco DevNet GitHub repo for the Hyperfabric Terraform Provider: https://github.com/CiscoDevNet/terraform-provider-hyperfabric/

################################################################################

This blueprint has the following high level flow:
* Variables - Nodes, Networks
* Node Mapping
* Define Fabric Blueprint
* Define Fabric Ports
* Define Node Connections - Pluggables
* Define Breakout Ports
* Define Host Ports
* Create VRF and logical networks with anycast gateway
* Create Loopback and assign to nodes
* Create Example Subinterfaces for BGP Peering
* Create Example Routed Interface for BGP Peering

To Do:
* Add BGP Peering configuration once it is supported via API/Terraform

################################################################################

Created by Michael Petrinovic 2025

WARNING:

These scripts are meant for educational/proof of concept purposes only - as demonstrated at Cisco Live and/or my other presentations. Any use of these scripts and tools is at your own risk. There is no guarantee that they have been through thorough testing in a comparable environment and I am not responsible for any damage or data loss incurred as a result of their use