#In this file, I list the steps I learned to install kubernetes on a Ubuntu 18.04 server.
#There are a couple of things that I learned from this experience.
#Networking: k8s needs to be able to reach the other k8s nodes. This doesn't come by default and you need to choose your own network.
#The networks of choice are: calico, flannel, weave, and others.
#In this file, I list the steps to install with calico as the network.

#these steps are for both servers.
#Next we need to enable kernel modules and configure sysctl.
#To enable kernel module
sudo modprobe overlay
sudo modprobe br_netfilter

#Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

#install container runtime
#we have some options here
#1. install docker
#2. install containerd
#3. install cri-o

#site: https://docs.mirantis.com/mcr/20.10/install/mcr-linux/ubuntu.html
#we are going to install docker through mirantis
#installing mirantis I followed these steps
#Use the apt-get remove command to uninstall Docker Community versions, if present.
sudo apt-get remove docker docker-engine docker-ce docker-ce-cli docker.io

#Install using the repository
sudo apt-get update

#Install packages to allow apt to use a repository over HTTPS.
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

#Temporarily store https://repos.mirantis.com in an environment variable. This variable assignment does not persist when the session ends:
DOCKER_EE_URL="https://repos.mirantis.com"

#Temporarily add a $DOCKER_EE_VERSION variable into your environment.
DOCKER_EE_VERSION=20.10

# Add Docker’s official GPG key using your customer Mirantis Container Runtime repository URL
curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | sudo apt-key add -

# Verify that you now have the key with the fingerprint DD91 1E99 5A64 A202 E859  07D6 BC14 F10B 6D08 5F96, by searching for the last eight characters of the fingerprint. Use the command as-is. It works because of the variable you set earlier
sudo apt-key fingerprint 6D085F96

# Set up the stable repository, using the following command as-is (which works due to the variable set up earlier in the process).
sudo add-apt-repository \
  "deb [arch=$(dpkg --print-architecture)] $DOCKER_EE_URL/ubuntu \
  $(lsb_release -cs) \
  stable-$DOCKER_EE_VERSION"


#to do on server/master controler node.
# Install Mirantis Container Runtime
sudo apt-get update

# Install the latest version of Mirantis Container Runtime and containerd, or go to the next step to install a specific version. Any existing installation of MCR is replaced
sudo apt-get install docker-ee docker-ee-cli  docker-ee-rootless-extras containerd.io

# Verify that MCR is installed correctly by running the hello-world image
sudo docker run hello-world

# Use MCR with Kubernetes
# MCR can be used to provide a container runtime for Kubernetes pods. It is possible to use MCR with Kubernetes directly without MKE. Just enable the cri-dockerplugin.
sudo systemctl enable --now cri-docker.service
# Check the status:
systemctl status cri-docker.socket
# From the above output, we can identify the default socket:
Listen: /run/cri-docker.sock

# Proceed and pull container images
sudo kubeadm config images pull --cri-socket /run/cri-docker.sock

# The below example can be used for a single node controller
sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --cri-socket /run/cri-docker.sock

 #now you have to install a cni plugin for calico
 kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml

#  Install Calico by creating the necessary custom resource.
kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

# Confirm that all of the pods are running with the following command.
watch kubectl get pods -ncalico-system

#sort some of the errors that come with the installation.
#add workers to the nodes.
#with this set up it will be easy to get the nodes up and running fast.

#other resources:
#https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
#https://computingforgeeks.com/mirantis-container-runtime-kubernetes-docker-swarm/
#https://docs.mirantis.com/mcr/20.10/install/mcr-linux/ubuntu.html
#https://citizix.com/how-to-set-up-kubernetes-cluster-on-ubuntu-20-04-with-kubeadm-and-cri-o/
