# Node-Hostname-Update

When setting up nodes in a cluster there are some redundant tasks that need to be performed for each node, especially if you need to rebuild this type of cluster often. Automation, however, is a little complicated to do since each server has things that are its own and not the same as the other servers. For example, each server has its own IP address and hostname. 

This is a simple script example about how to perform most of these hostname related tasks automatically on a system based on CentOS or Red Hat Linux. It was written for a Hadoop cluster, but it can be used for any type of cluster and likewise on any Linux systems, with some modifications.

It is especially useful when creating the nodes from a VM template since that will create multiple identical nodes, but not address the issue of having different hostnames. 

The script does not address the task of setting up passwordless SSH, but it assumes it is set up. 
