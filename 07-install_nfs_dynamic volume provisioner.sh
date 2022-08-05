#setting up nfs server
#in order to have dynamiv volume provisioning for kubernetes you have to set up the nfs server
#otherwise you will get pending errors with the volume provisioner
#you can use the following commands to set up the nfs server
#these isntructions are for ubuntu 20.04

#install server packages
sudo apt-get install nfs-kernel-server
#update the server
sudo apt-get update

#install the client packages/ this must be done on all the client nodes
sudo apt-get install nfs-common

#update the client
sudo apt-get update

#create shared directory on master server
sudo mkdir /var/nfs/general -p

#If you perform any root operations on the client, then NFS will translate them to nobody:nogroup credentials on the host machine.
#Therefore, we need to give appropriate ownership to the shared directory.
sudo chown nobody:nogroup /var/nfs/general

#test on client if you can mount the shared directory/ if there is no error it will just go to the next prompt
mount -t nfs 137.63.194.17:/var/nfs/general /mnt

#unmount the shared directory when done
sudo umount /mnt

#install helm
curl -L https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz | tar xz -C /usr/local/bin

#add the heml chart from this repo: https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/tree/v4.0.2
#the two instructions below will assist
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path

#install the subdir provisioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=137.63.194.17 --set nfs.path=/var/nfs/general

#note: the name of the storage class is: nfs-client
#there is a manual way all this can be done but helm chart makes it easier.

#resources:
https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/tree/v4.0.2
https://www.youtube.com/watch?v=DF3v2P8ENEg&t=48s
https://www.howtoforge.com/how-to-install-nfs-client-and-server-on-ubuntu-2004/

#rasa installation notes
#in order to make rasa work with this dynamic installation,you need to add the nsf-client storage class to the rasa deployment
#this can be done through the helm installation, there is an option for it in the rasa chart
#trying to change this on the deployment or pod level will cause errors and it forbidden to do so.
