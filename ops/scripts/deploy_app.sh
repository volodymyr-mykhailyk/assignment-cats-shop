#Clean up docker
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)

docker run -e RACK_ENV=production -e DATABASE_URL=${DATABASE_URL} ${RELEASE_IMAGE} bundle exec rake db:create db:migrate db:seed
docker run -d -p 80:3000 --name app -e RACK_ENV=production -e DATABASE_URL=${DATABASE_URL} ${RELEASE_IMAGE} bundle exec rackup -p 3000
