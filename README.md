# docker-gpweb
A Dockerfile that installs GPWEB

## Installation

```
git clone https://github.com/lavanco/docker-gpweb.git
cd docker-gpweb
docker build -t lavanco/docker-gpweb .
```

## Usage

```
# Start DB
docker run \
       -d \
       --name mariadb -h mariadb \
       -e MYSQL_ROOT_PASSWORD=root \
       -p 3306:3306 \
       -v /etc/localtime:/etc/localtime:ro \
       -v /var/lib/mysql:/var/lib/mysql \
        mariadb

# Start GPWEB
docker run \
       -d \
       --name gpweb -h gpweb \
       -p 80:80 -p 443:443 \
       -v /etc/localtime:/etc/localtime:ro \
       docker-gpweb

# Access http://localhost
# Follow instructions to install GPWEB.