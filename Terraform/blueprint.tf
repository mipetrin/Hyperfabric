################################################################################
# Example crafted by Michael Petrinovic (mipetrin@cisco.com), 2025             #
# Based off the Hyperfabric documentation available at the Cisco DevNet GitHub #
# repo for the Hyperfabric Terraform Provider:                                 #
#                                                                              #
# https://github.com/CiscoDevNet/terraform-provider-hyperfabric/               #
################################################################################
#
# This blueprint has the following high level flow:
#   Variables - Nodes, Networks
#   Node Mapping
#   Define Fabric Blueprint
#   Define Fabric Ports
#   Define Node Connections - Pluggables
#   Define Breakout Ports
#   Define Host Ports
#   Create VRF and logical networks with anycast gateway
#   Create Loopback and assign to nodes
#   Create Example Subinterfaces for BGP Peering
#   Create Example Routed Interface for BGP Peering


################################################
# Variables for each node and important info   #
################################################

variable "nodes" {
  default = {
   1 = {
         name       = "CiscoLive-leaf1",
         model_name = "HF6100-32D",
         roles      = ["LEAF"],
         serial_number = "ABCDL001",
         description   = "Leaf 1",
         location      = "NSD-24",
         labels        = ["blue", "red", "green"]
       },
   2 = {
         name       = "CiscoLive-leaf2",
         model_name = "HF6100-32D",
         roles      = ["LEAF"],
         serial_number = "ABCDL002",
         description   = "Leaf 2",
         location      = "NSD-24",
         labels        = ["blue", "red", "green"]
       },
   3 = {
         name       = "CiscoLive-leaf3",
         model_name = "HF6100-60L4D",
         roles      = ["LEAF"],
         serial_number = "ABCDL003",
         description   = "Leaf 3",
         location      = "NSD-24",
         labels        = ["blue", "red", "green"]
       },
   4 = {
         name       = "CiscoLive-leaf4",
         model_name = "HF6100-60L4D",
         roles      = ["LEAF"],
         serial_number = "ABCDL004",
         description   = "Leaf 4",
         location      = "NSD-24",
         labels        = ["blue", "red", "green"]
       },
   5 = {
         name       = "CiscoLive-spine1",
         model_name = "HF6100-32D",
         roles      = ["SPINE"],
         serial_number = "ABCDS001",
         description   = "Spine 1",
         location      = "NSD-24",
         labels        = ["blue", "red", "green"]
       },
   6 = {
         name       = "CiscoLive-spine2",
         model_name = "HF6100-32D",
         roles      = ["SPINE"],
         serial_number = "ABCDS002",
         description   = "Spine 2",
         location      = "NSD-24",
         labels        = ["blue", "red", "green"]
       }
  }
}

variable "my_networks" {
  default = {
   1 = {
         name       = "network-three",
         description   = "Network three VNI",
         #vni      = "1202603",
         svi = {
          enabled        = true
          ipv4_addresses = ["192.168.3.1/24"]
          ipv6_addresses = ["2001:192:168:3::1/64"]
         }
         vlan     = 300
         port     = "Ethernet1_5"
       },
   2 = {
         name       = "network-four",
         description   = "Network four VNI",
         #vni      = "1202604",
         svi = {
          enabled        = true
          ipv4_addresses = ["192.168.4.1/24"]
          ipv6_addresses = ["2001:192:168:4::1/64"]
         }
         vlan     = 400
         port     = "Ethernet1_5"
       },
  }
}

################################################
# Create fabric blueprint first - no nodes yet #
################################################

resource "hyperfabric_fabric" "fab1" {
  name        = "TF-CiscoLiveMel-2025"
  address     = "177 Pacific Highway"
  city        = "Sydney"
  country     = "AUS"
  location    = "NSD lab"
  description = "TERRAFORM Example by Michael Petrinovic = mipetrin@cisco.com"
  labels = [
    "nsd",
    "lab",
    "se",
    "Terraform"
  ]
  annotations = [
    {
      data_type = "STRING"
      name      = "owner"
      value     = "Mike"
    },
    {
      name  = "rack"
      value = "R2"
    }
  ]
} 

################################################
# Iterate through nodes obj and create nodes   #
################################################

resource "hyperfabric_node" "nodemap" {
  fabric_id     = hyperfabric_fabric.fab1.id
  for_each      = var.nodes
  name          = each.value["name"]
  roles         = each.value["roles"]
  serial_number = each.value["serial_number"]
  description   = each.value["description"]
  model_name    = each.value["model_name"]
  location      = each.value["location"]
  labels        = each.value["labels"]
}

# Uncomment to debug and display all node names
# output "all_node_names" {
#     value = [for node in hyperfabric_node.nodemap : node.name]
# }

################################################
# Configure fabric ports on all switches       #
################################################

resource "hyperfabric_node_port" "node1_eth1_1" {
  node_id = hyperfabric_node.nodemap.1.id
  name    = "Ethernet1_1"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node2_eth1_1" {
  node_id = hyperfabric_node.nodemap.2.id
  name    = "Ethernet1_1"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node3_eth1_1" {
  node_id = hyperfabric_node.nodemap.3.id
  name    = "Ethernet1_1"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node4_eth1_1" {
  node_id = hyperfabric_node.nodemap.4.id
  name    = "Ethernet1_1"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node1_eth1_2" {
  node_id = hyperfabric_node.nodemap.1.id
  name    = "Ethernet1_2"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node2_eth1_2" {
  node_id = hyperfabric_node.nodemap.2.id
  name    = "Ethernet1_2"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node3_eth1_2" {
  node_id = hyperfabric_node.nodemap.3.id
  name    = "Ethernet1_2"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node4_eth1_2" {
  node_id = hyperfabric_node.nodemap.4.id
  name    = "Ethernet1_2"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node5_eth1_1" {
  node_id = hyperfabric_node.nodemap.5.id
  name    = "Ethernet1_1"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node5_eth1_2" {
  node_id = hyperfabric_node.nodemap.5.id
  name    = "Ethernet1_2"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node5_eth1_3" {
  node_id = hyperfabric_node.nodemap.5.id
  name    = "Ethernet1_3"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node5_eth1_4" {
  node_id = hyperfabric_node.nodemap.5.id
  name    = "Ethernet1_4"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node6_eth1_1" {
  node_id = hyperfabric_node.nodemap.6.id
  name    = "Ethernet1_1"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node6_eth1_2" {
  node_id = hyperfabric_node.nodemap.6.id
  name    = "Ethernet1_2"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node6_eth1_3" {
  node_id = hyperfabric_node.nodemap.6.id
  name    = "Ethernet1_3"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node6_eth1_4" {
  node_id = hyperfabric_node.nodemap.6.id
  name    = "Ethernet1_4"
  roles   = ["FABRIC_PORT"]
  enabled = "true"
}

################################################
# Connect the nodes together as a Clos fabric  #
################################################

resource "hyperfabric_connection" "node1-spine1" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.1.node_id
    port_name = "Ethernet1_1"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.5.node_id
    port_name = "Ethernet1_1"
  }
  pluggable = "QDD-400-AOC25M"
}

resource "hyperfabric_connection" "node1-spine2" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.1.node_id
    port_name = "Ethernet1_2"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.6.node_id
    port_name = "Ethernet1_1"
  }
  pluggable = "QDD-400-AOC10M"
}

resource "hyperfabric_connection" "node2-spine1" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.2.node_id
    port_name = "Ethernet1_1"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.5.node_id
    port_name = "Ethernet1_2"
  }
  pluggable = "QDD-400-AOC10M"
}

resource "hyperfabric_connection" "node2-spine2" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.2.node_id
    port_name = "Ethernet1_2"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.6.node_id
    port_name = "Ethernet1_2"
  }
  pluggable = "QDD-400-AOC10M"
}

resource "hyperfabric_connection" "node3-spine1" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.3.node_id
    port_name = "Ethernet1_1"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.5.node_id
    port_name = "Ethernet1_3"
  }
  pluggable = "QDD-400-AOC10M"
}

resource "hyperfabric_connection" "node3-spine2" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.3.node_id
    port_name = "Ethernet1_2"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.6.node_id
    port_name = "Ethernet1_3"
  }
  pluggable = "QDD-400-AOC10M"
}

resource "hyperfabric_connection" "node4-spine1" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.4.node_id
    port_name = "Ethernet1_1"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.5.node_id
    port_name = "Ethernet1_4"
  }
  pluggable = "QDD-400-AOC10M"
}

resource "hyperfabric_connection" "node4-spine2" {
  fabric_id = hyperfabric_fabric.fab1.id
  local = {
    node_id   = hyperfabric_node.nodemap.4.node_id
    port_name = "Ethernet1_2"
  }
  remote = {
    node_id   = hyperfabric_node.nodemap.6.node_id
    port_name = "Ethernet1_4"
  }
  pluggable = "QDD-400-AOC10M"
}


################################################
# Breakout Eth1/7-8 on node-1                  #
################################################

resource "hyperfabric_node_breakout" "node1_Ethernet1_7-8" {
  node_id     = hyperfabric_node.nodemap.1.id
  name        = "Ethernet1_7-8"
  description = "Ports to be configured as Breakout"
  ports       = ["Ethernet1_7", "Ethernet1_8"]
  mode        = "4x25G(4)"
  pluggable   = "QSFP-4SFP25G-CU1M"
  labels = [
    "NSD-24",
    "blue"
  ]
  annotations = [
    {
      name  = "color"
      value = "blue"
    },
    {
      data_type = "UINT32"
      name      = "Rack"
      value     = "2"
    }
  ]
}


################################################
# Make eth1/5 a host port on node-1 and node-2 #
################################################

resource "hyperfabric_node_port" "node1_eth1_5" {
  node_id = hyperfabric_node.nodemap.1.id
  name    = "Ethernet1_5"
  roles   = ["HOST_PORT"]
  enabled = "true"
}

resource "hyperfabric_node_port" "node2_eth1_5" {
  node_id = hyperfabric_node.nodemap.2.id
  name    = "Ethernet1_5"
  roles   = ["HOST_PORT"]
  enabled = "true"
}

################################################
# Create VRF and logical networks + anycast gw #
################################################

resource "hyperfabric_vrf" "my_vrf" {
  fabric_id = hyperfabric_fabric.fab1.id
  name      = "Vrf-Mike"
}

resource "hyperfabric_vni" "network-one" {
  fabric_id   = hyperfabric_fabric.fab1.id
  name        = "network-one"
  description = "Network one VNI"
  vni         = 10000
  svi = {
    enabled        = true
    ipv4_addresses = ["192.168.1.254/24"]
    ipv6_addresses = ["2001:192:168:1::1/64"]
  }
  members = [
  {
      node_id   = hyperfabric_node.nodemap.1.node_id
      port_name = "Ethernet1_5"
      vlan_id   = 100
    },
    {
      node_id   = hyperfabric_node.nodemap.2.node_id
      port_name = "Ethernet1_5"
      vlan_id   = 100
    }
  ]
  vrf_id = hyperfabric_vrf.my_vrf.vrf_id
}

resource "hyperfabric_vni" "network-two" {
  fabric_id   = hyperfabric_fabric.fab1.id
  name        = "network-two"
  description = "Network two VNI"
  #vni         = 20000
  svi = {
    enabled        = true
    ipv4_addresses = ["192.168.2.254/24"]
    ipv6_addresses = ["2001:192:168:2::1/64"]
  }
  members = [ 
  {
      node_id   = hyperfabric_node.nodemap.1.node_id
      port_name = "Ethernet1_5"
      vlan_id   = 200
    },
    {
      node_id   = hyperfabric_node.nodemap.2.node_id
      port_name = "Ethernet1_5"
      vlan_id   = 200
    }
  ]
  vrf_id = hyperfabric_vrf.my_vrf.vrf_id
}

################################################
# Iterate through networks obj and create more #
################################################

resource "hyperfabric_vni" "networkmap" {
  fabric_id     = hyperfabric_fabric.fab1.id
  for_each      = var.my_networks
  name          = each.value["name"]
  description   = each.value["description"]
  #vni           = each.value["vni"]
  svi           = each.value["svi"]
  members = [ 
  {
      node_id   = hyperfabric_node.nodemap.1.node_id
      port_name = each.value["port"]
      vlan_id   = each.value["vlan"]
    },
    {
      node_id   = hyperfabric_node.nodemap.2.node_id
      port_name = each.value["port"]
      vlan_id   = each.value["vlan"]
    }
  ]
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}

# Uncomment to debug and display all network names from variables.tf
# output "all_network_names" {
#     value = [for networks in hyperfabric_vni.networkmap : networks.name]
# }

################################################
# Create Loopback and assign to nodes          #
################################################

resource "hyperfabric_node_loopback" "node1_loopback10" {
  node_id     = hyperfabric_node.nodemap.1.id
  name         = "Loopback10"
  ipv4_address = "10.1.0.1/32"
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}

resource "hyperfabric_node_loopback" "node2_loopback10" {
  node_id     = hyperfabric_node.nodemap.2.id
  name         = "Loopback10"
  ipv4_address = "10.1.0.2/32"
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}

resource "hyperfabric_node_loopback" "node3_loopback10" {
  node_id     = hyperfabric_node.nodemap.3.id
  name         = "Loopback10"
  ipv4_address = "10.1.0.3/32"
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}

resource "hyperfabric_node_loopback" "node4_loopback10" {
  node_id     = hyperfabric_node.nodemap.4.id
  name         = "Loopback10"
  ipv4_address = "10.1.0.4/32"
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}

################################################
# Create Example Subinterfaces for BGP Peering #
################################################

resource "hyperfabric_node_sub_interface" "node1_Ethernet1_6_100" {
  node_id = hyperfabric_node.nodemap.1.id
  name    = "Ethernet1_6.100"
}

resource "hyperfabric_node_sub_interface" "node1_Ethernet1_6_101" {
  node_id        = hyperfabric_node.nodemap.1.id
  name           = "Ethernet1_6.101"
  description    = "Loopback for BGP peering"
  enabled        = true
  ipv4_addresses = ["10.8.0.1/24"]
  ipv6_addresses = ["2004:1::1/64", "2005:1::1/64"]
  vlan_id        = 800
  vrf_id         = hyperfabric_vrf.my_vrf.vrf_id
  labels = [
    "NSD-24",
    "blue"
  ]
  annotations = [
    {
      name  = "color"
      value = "blue"
    },
    {
      data_type = "UINT32"
      name      = "rack"
      value     = "2"
    }
  ]
}

###################################################
# Create Example Routed Interface for BGP Peering #
###################################################

resource "hyperfabric_node_port" "node1_eth1_4" {
  node_id = hyperfabric_node.nodemap.1.id
  name    = "Ethernet1_4"
  roles   = ["ROUTED_PORT"]
  enabled = "true"
  ipv4_addresses = ["10.40.1.2/30"]
  description = "Routed Port for L3 Connection to upstream eBGP Router"
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}

resource "hyperfabric_node_port" "node2_eth1_4" {
  node_id = hyperfabric_node.nodemap.2.id
  name    = "Ethernet1_4"
  roles   = ["ROUTED_PORT"]
  enabled = "true"
  ipv4_addresses = ["10.40.2.2/30"]
  description = "Routed Port for L3 Connection to upstream eBGP Router"
  vrf_id        = hyperfabric_vrf.my_vrf.vrf_id
}