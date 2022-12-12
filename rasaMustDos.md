### These are things one has to do after installing rasax using helm charts
1 - Install k3s for the cluster: this can be done from k3s.io (ths script takes about 30secs to run)
2 - Install helm if you don't have it.
3 - Install prometheus for monitoring. (This is done after installing the k3s cluster)
4 - Make sure you are using scipy 1.5.4 in your training env (on your server the .18 one so that we don't have authentication issue): This module makes it easy for the models to be transferable.
5 - Transfer the models created through the api since the servers are on the same network if not, then just copy and paste.
6 - To add channels: please transfer the erlang cookie to the release update before trying updates.
7 - Update the release.
8 - Add the channels: rest and the socketio channels.
9 - Turn the production service into a loadbalancer (this is if you have not set up the tls/ssl server and ingress rules)
10 - Attach the widget for the frontend app.(this can be done only when the speeds at the backend are fast enough.)

- For kubernetes scaling, set it to autoscaling so that the cluster will self heal otherwise the load might be too much for the network.
**  Get the certificate for the domain name you are going to use: (http://chatbot.aceuganda.org/)

- Creating ingress routes:
 This link will assist in creating ingress routes and certificates: [Certificates](https://www.padok.fr/en/blog/traefik-kubernetes-certmanager)


### Things to try next time when installing the k3s instance:
- Don't install traefik along with the rest of the installation, install it later so you can have more access to the options it avails.

### Spinning up an HA k3s cluster with Ansible
- https://www.youtube.com/watch?app=desktop&v=CbkEWcUZ7zM
- https://github.com/techno-tim/k3s-ansible
#### This link here below is what I should probably follow in order to get things working with https/ssl
-[ https://www.youtube.com/watch?v=G4CmbYL9UPg](https://docs.technotim.live/posts/kube-traefik-cert-manager-le/)
