# Kubernetes Installation

I wish for this repo to help someone out there who is struggling with deploying k8 on an on-prem cluster.

These are some of the things you should know.

For administration:
- Install the lens application: it makes life easy
- Create a tunnel into the server and connect to your control place port

```
ssh -fNL <port>:x.x.x.x:<port> <server credentials> e.g admin@x.x.x.x
```
On your local machine check the tunnel like this

```
sudo netstat -nltp | grep <port>

```

Follow this process:

## Server:
- Install docker
- Install kubectl, kubeadm, kubelet and containerd
- Install flannel for the network of the pods
- Install nfs server for dynamic provisioning of volume.

## Client
- Install docker
- Install kubectl, kubeadm, kubelet
- Install nfs-common to helm mount the folders on the master

For my use case I employed flannel for my network and not calico because I honestly could not figure out the way to install the later, but I am willing to learn more.
