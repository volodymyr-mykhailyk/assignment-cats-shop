#!/bin/bash

set -ex

#Install Docker
sudo yum update -y
sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

#Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Launch application
sudo docker run -e RACK_ENV=production -e DATABASE_URL=${database_url} vnovitskyi/assignment-kittens-store:latest bundle exec rake db:create db:migrate db:seed
sudo docker run -d -p 80:3000 --name app -e RACK_ENV=production -e DATABASE_URL=${database_url} vnovitskyi/assignment-kittens-store:latest bundle exec rackup -p 3000