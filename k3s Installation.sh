#this is the installation that finally worked:
# documentation: k3s.io
#example: https://gitlab.com/cloud-versity/rancher-k3s-first-steps
# https://www.youtube.com/watch?v=O3s3YoPesKs

#k3s installation on my server
#in the docs there are many options that one can use to install k3s
curl -sfL https://get.k3s.io | sh -s - --node-ip 137.63.194.17 --advertise-address 137.63.194.17 --advertise-port 34801 --https-listen-port 34801 --service-node-port-range 30000-30100 --node-name master

#uninstall master
#this will help clean up all the information that k3s has installed on the master node
/usr/local/bin/k3s-uninstall.sh

#agent uninstall will help clean up all the information that k3s has installed on the agent nodes
/usr/local/bin/k3s-agent-uninstall.sh

#get token that is used to join the cluster
cat /var/lib/rancher/k3s/server/node-token

#example setup for joining the cluster
curl -sfL https://get.k3s.io | K3S_NODE_NAME=k3s-worker-02 K3S_URL=https://137.63.194.17:34801 K3S_TOKEN=K10f8cea1ae35c6002acf234e22662543b8afb6d77f68ea543056f0bbe097c525a4::server:09e18eb81bb4ec13d7d274c766f66a5b sh -

# Leverage the KUBECONFIG environment variable:
# Please do not forget this step, its very important for you to be able to use kubectl on the command line.
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get pods --all-namespaces
helm ls --all-namespaces

Date: 2023-Feb-23
#sometimes there is a permission issue with k3s
#for that use the link below to solve the issue.
# http://vcloud-lab.com/entries/devops/rancher-k3s-yaml-permission-denied-when-using-kubectl-kubernetes

#see permissions with this command
ls -lsa /etc/rancher/k3s/k3s.yaml

#change to admin access with this command
sudo chown admin:admin /etc/rancher/k3s/k3s.yaml
