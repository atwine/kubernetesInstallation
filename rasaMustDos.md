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
**  Get the certificate for the domain name you are going to use:
