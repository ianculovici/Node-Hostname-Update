#!/bin/sh
#
# box_setup.sh
#

#
# C O N F I G
#
NodeNamePrefix=testnode
domain=example.com
maxnode=4

NodesIp="10.0.0.1 10.0.0.2 10.0.0.3 10.0.0.4"

# Constructing the node names using a given prefix, a domain name, and a numeric index.
# Note that you can also set these names to be whatever you want by listing the names 
# (separated by space) in the NodesNames variable.

NodesNames=""
NodesNamesNoDomain=""
for i in `seq 1 $maxnode`; do
  NodesNames="${NodesNames} ${NodeNamePrefix}$i.${domain}"
  NodesNamesNoDomain="${NodesNamesNoDomain} ${NodeNamePrefix}${i}"
done

Nodes=($NodesNames)
NodesNoDomain=($NodesNamesNoDomain)
NodesIP=($NodesIp)

#
# P R O G R A M   F U N C T I O N S
#

distribute_etc_hosts(){
  # It creates a /etc/hosts files from the list of nodes and IP addresses and 
  # it distributes it to all nodes.

  h1='127.0.0.1       localhost localhost.localdomain localhost4 localhost4.localdomain4\n'
  h2='::1         localhost localhost.localdomain localhost6 localhost6.localdomain6\n'

  lines=""
  for i in "${!Nodes[@]}"; do
    lines="${lines}${NodesIP[$i]} ${Nodes[$i]} ${NodesNoDomain[$i]}\n"
  done

  printf "${h1}${h2}${lines}" > /etc/hosts
  for node in ${Nodes[@]:1}; do scp /etc/hosts $node:/etc ; done
}

set_sysconfig_network(){
  # It creates a /etc/sysconfig/network files from the list of nodes and IP addresses 
  # and it distributes it to all nodes.

  for node in ${Nodes[@]}; do ssh $node "printf \"NETWORKING=yes\nHOSTNAME=${node}\n\" > /etc/sysconfig/network" ; done
}

set_etc_hostname(){
  # It overwrites the /etc/hostname file with the hostname specific for the node
  
  for node in ${Nodes[@]}; do ssh $node "printf \"${node}\n\" > /etc/hostname" ; done
}

#
#    M A I N 
#
distribute_etc_hosts
set_sysconfig_network
set_etc_hostname
