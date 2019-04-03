#!/bin/bash

#############################################################################
# COLOURS AND MARKUP
#############################################################################

red='\033[0;31m'            # Red
green='\033[0;49;92m'       # Green
yellow='\033[0;49;93m'      # Yellow
white='\033[1;37m'          # White
grey='\033[1;49;30m'        # Grey
nc='\033[0m'                # No color

clear

echo -e "${yellow}
# Test if machine is running in swarm if not start it
#############################################################################${nc}"
if docker node ls > /dev/null 2>&1; then
  echo already running in swarm mode
else
  docker swarm init
  echo docker was a standalone node now running in swarm
fi

echo -e "${yellow}
# Test if network is running in overlay if not start it
#############################################################################${nc}"
docker network ls|grep appnet > /dev/null || docker network create --driver overlay appnet
sleep 5
echo -e "${green}Done....${nc}"


echo -e "${yellow}
# Create secrets for db use
#############################################################################${nc}"
echo -e "${green}Choose new database root password: ${nc}"
read moodle_db_root_pwd
printf $moodle_db_root_pwd | docker secret create moodle_db_root_pwd -
echo -e "${green}Done....${nc}"


echo -e "${green}Choose new database dba password: ${nc}"
read moodle_db_dba_pwd
printf $moodle_db_dba_pwd | docker secret create moodle_db_dba_pwd -
echo -e "${green}Done....${nc}"

echo -e "${yellow}
# Create config for mysql container 
#############################################################################${nc}"
docker config create my_cnf config_mysql/my.cnf
echo -e "${green}Done....${nc}"


echo -e "${yellow}
# Setup database for initial use
#############################################################################${nc}"
docker-compose build moodle-db
echo -e "${green}Done....${nc}"


echo -e "${yellow}
# Setup moodle for initial use
#############################################################################${nc}"
docker-compose build moodle
echo -e "${green}Done....${nc}"


echo -e "${yellow}
# Create folderstructure for moodle for initial use
#############################################################################${nc}"
mkdir .data
mkdir .data/moodle
mkdir .data/moodle/moodledb
mkdir .data/moodle/data
echo -e "${green}Done....${nc}"


echo -e "${yellow}
# Setup moodle for initial use
#############################################################################${nc}"
docker stack deploy -c docker-compose.yml moodle
sleep 30
containerid="$(docker container ps -q -f 'name=moodle-db')"
echo $containerid
#docker exec -it $containerid chown -R mysql:mysql /var/lib/mysql
#docker cp init_db.sh $containerid:/init_db.sh
#docker exec -it $containerid ./init_db.sh
#docker exec -it $containerid rm /init_db.sh

echo -e "${green}Done....${nc}"
