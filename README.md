# docker-gpweb
A Dockerfile that installs GPWEB

![https://www.sistemagpweb.com/](https://www.sistemagpweb.com/sites/all/themes/gpweb/css/images/logo.png)

[![Docker layers](https://images.microbadger.com/badges/image/lavanco/gpweb.svg)](https://microbadger.com/images/lavanco/gpweb) [![Docker Pulls](https://img.shields.io/docker/pulls/lavanco/gpweb.svg)](https://hub.docker.com/r/lavanco/gpweb/) [![Docker Build Status](https://img.shields.io/docker/build/lavanco/gpweb.svg)](https://hub.docker.com/r/lavanco/gpweb/) [![GitHub last commit](https://img.shields.io/github/last-commit/lavanco/docker-gpweb.svg)](https://github.com/lavanco/docker-gpweb)

This image is based on CentOS operating system and contains the basic packages necessary for the operation of [GPWEB](https://www.sistemagpweb.com/).

## Version

- GPWEB: 8.5.19

## Installation

From Github:

```
git clone https://github.com/lavanco/docker-gpweb.git

cd docker-gpweb

docker build -t lavanco/docker-gpweb:8.5.19 .
```

From Docker Hub:

```
docker pull lavanco/gpweb:8.5.19
```

## Usage

GPWEB container using docker-compose

```
git clone https://github.com/lavanco/docker-gpweb.git

cd docker-gpweb

docker network create -d bridge prod

docker volume create mysql-data

docker-compose up -d
```

GPWEB container using ` docker run `

```
docker volume create mysql-data

docker run \
       -d \
       --name mariadb -h mariadb \
       -e MYSQL_ROOT_PASSWORD=rootpassword \
       -p 3306:3306 \
       -v mysql-data:/var/lib/mysql \
       -v /etc/localtime:/etc/localtime:ro \
       --network prod \
       mariadb:10.3.14

docker run \
       -d \
       --name gpweb -h gpweb \
       -p 80:80 -p 443:443 \
       -v /etc/localtime:/etc/localtime:ro \
       --network prod \
       lavanco/gpweb:8.5.19
```

Access [http://localhost](http://localhost) and follow instructions to install GPWEB.
