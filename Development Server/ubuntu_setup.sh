#!/bin/bash
echo "⚙️  Updating server"
apt-get -qq update > /dev/null 2>&1
apt-get upgrade -qq -y > /dev/null 2>&1

echo "🛠  Installing tools"
apt-get install docker git python3 -qq -y > /dev/null

echo "🐙  Cloning Git Repo"
git clone --quiet https://github.com/rorymurdock/Docker.git

echo "🐳  Configuring Docker"
ip_address=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
cd Docker/RunDeck
touch realm.properties
docker build -q -t rorym/rundeck -f Dockerfile . > /dev/null
docker run --name rundeck -v ~/rundeck/db:/home/rundeck/server/data -v ~/rundeck/scripts:/opt/scripts -d -p 4440:4440 -e RUNDECK_GRAILS_URL=http://$ip_address:4440  rorym/rundeck > /dev/null

##### Use the below to clean up if you're testing this script a few times ####
# echo "🚿  Cleaning up"
# docker stop $(docker ps -aq)
# docker rm $(docker ps -aq)
# docker rmi $(docker images -q)
#ssh $user@$server 'rm -rf ~/.ssh'
echo "✅  Script completed"
printf "🏁  "