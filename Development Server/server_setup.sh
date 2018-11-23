#!/bin/bash
##### Vars #####
# IP/hostname of new server
server="172.16.0.145"
# Username
user="svradmin"
# Path to public key
ssh_public_key=$(cat ~/.ssh/id_rsa.pub)
# Setup script
setup_script='./ubuntu_setup.sh'
# Server script directory
remote_directory='/tmp/'

echo "🔦  Connecting to server"
printf "🔐  "
if !(ssh $user@$server "mkdir -p ~/.ssh; echo $ssh_public_key >> ~/.ssh/authorized_keys")
then
    echo "❌ Error connecting to server"
    exit
fi

echo "🚛  Copying setup script"
if !(scp -q $setup_script $user@$server:$remote_directory/setup.sh)
then
    echo "❌ Unable to copy setup script to server"
    exit
fi

echo "🚀  Running script on server"
printf "🔑  "
if !(ssh -t $user@$server "sudo sh $remote_directory/setup.sh")
then
    echo "❌ Unable to run script on server"
    exit
fi


echo "🚿  Cleaning up"
ssh $user@$server 'rm -rf ~/.ssh'