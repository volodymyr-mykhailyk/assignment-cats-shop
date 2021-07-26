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
sudo docker network create cats_shop
sudo docker run -d -p 5432:5432 --name database --network=cats_shop -e POSTGRES_PASSWORD=pass -e POSTGRES_USER=app postgres
sudo docker run --network=cats_shop -e RACK_ENV=production -e DATABASE_URL=postgres://app:pass@database:5432/cats_shop vnovitskyi/assignment-kittens-store:latest bundle exec rake db:create db:migrate db:seed
sudo docker run -d -p 80:3000 --name app --network=cats_shop -e RACK_ENV=production -e DATABASE_URL=postgres://app:pass@database:5432/cats_shop vnovitskyi/assignment-kittens-store:latest bundle exec rackup -p 3000