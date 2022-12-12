#https://www.digitalocean.com/community/tutorials/how-to-set-up-jupyter-notebook-with-python-3-on-ubuntu-20-04-and-connect-via-ssh-tunneling#fromHistory
#https://linuxhint.com/install-anaconda-ubuntu-22-04/

pip3 install pycaret[full]==3.0.0rc1 --use-deprecated=backtrack-on-build-failures
- ssh ubuntu@102.34.160.47 -i <private_key>
- ssh -L 8888:localhost:8888 ubuntu@102.34.160.47 -i Jupyter-Hub-2.pem
- ssh ubuntu@102.34.160.47 -i Jupyter-Hub-2.pem

#for mac
- ssh -L 8888:localhost:8888 ubuntu@102.34.160.47 -i <private key>

#uninstall virtual env

#install conda

#create conda env
