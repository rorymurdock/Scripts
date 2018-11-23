#!/bin/bash
echo "⚙️  Updating server"
apt-get -qq update
apt-get upgrade -qq -y  >> /dev/null

echo "🛠  Installing tools"
apt-get install docker git python3 -qq -y >> /dev/null

echo "🐙  Configuring Git"
#TODO
git clone https://github.com/rorymurdock/Docker.git

echo "🐳  Configuring Docker"
ip_address=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
docker build -t rorym/rundeck -f Dockerfile ./Docker/RunDeck
docker run --name rundeck -v /var/rundeck/db:/home/rundeck/server/data -v /var/rundeck/scripts:/opt/mdmscripts -d -p 4440:4440 -e RUNDECK_GRAILS_URL=http://$ip_address:4440  wowsie/rundeck

echo "✅  Script completed"
printf "🏁  "