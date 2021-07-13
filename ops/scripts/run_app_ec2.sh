set -ex

docker run -d -p 80:80 --name app nginxdemos/hello:plain-text