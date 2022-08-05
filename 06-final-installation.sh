#this is the installation that actually worked for the servers at idi/ACE
#video link https://www.youtube.com/watch?v=DS1azfsMYvQ

#add the google repos to the apt-get sources.list file
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "kubeadm install"

#update the apt-get sources.list file
sudo apt update -y

#install the kubeadm, kubelet, and kubectl packages
sudo apt -y install vim git curl wget kubelet=1.24.3-00 kubeadm=1.24.3-00 kubectl=1.24.3-00

#turn off swap temporarily
# vi /etc/fstab
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

#network configs
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

#enable the configs for network
sudo sysctl --system

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

#enable the configs for network
sudo sysctl --system

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# update the apt-get sources.list file
sudo apt update

# install containerd.io
sudo apt install -y containerd.io
mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

sudo systemctl enable kubelet

#on the master server run the following commands on the master server
sudo kubeadm config images pull --cri-socket /run/containerd/containerd.sock --kubernetes-version v1.24.3

#initiate the kubeadm cluster on the master server only
#to get more information use the link below
#you can choose the piblic ip of the master node for the control-plane-endpoint and an open port for the api-server-port
#https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --upload-certs --kubernetes-version=v1.24.3  --control-plane-endpoint=10.35.50.53 --ignore-preflight-errors=all  --cri-socket /run/containerd/containerd.sock
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --upload-certs --kubernetes-version=v1.24.3 --apiserver-bind-port=34801 --control-plane-endpoint=137.63.194.17 --ignore-preflight-errors=all  --cri-socket /run/containerd/containerd.sock

#keep the kubeadm config file in the home directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

#install  the flannel network
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

#remove the taints from the master node so that pods can be deployed on it also.
kubectl taint node $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint node $(hostname) node-role.kubernetes.io/master:NoSchedule-

#install helm to help with installation of kubernetes apps.
wget https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar -xvf helm-v3.7.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/

#to make sure some of the pods are assigned to the control plane:
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

#the response will look like this
#-node/kla-ac-bot-01 untainted
#-error: taint "node-role.kubernetes.io/control-plane" not found
# therefore you can shcedule on this node also.

#How to schedule some pods on the master control plane:
#https://computingforgeeks.com/how-to-schedule-pods-on-kubernetes-control-plane-node/
# Use this command the way it is
kubectl taint nodes --all node-role.kubernetes.io/master-

#joining commands
You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 137.63.194.17:34801 --token mg11ce.buglsrlmulysvmks \
        --discovery-token-ca-cert-hash sha256:e00dda337ad7cc50ea4781b931e1f80b13663b4d206f619f9a82c67abcef26ef \
        --control-plane --certificate-key 9f8b8ead53c43fac4fe2d7b485f1ae55eb4ccc621b1cb38f41c7736f260651bc

sudo kubeadm join 137.63.194.17:34801 --token mg11ce.buglsrlmulysvmks --discovery-token-ca-cert-hash sha256:e00dda337ad7cc50ea4781b931e1f80b13663b4d206f619f9a82c67abcef26ef
