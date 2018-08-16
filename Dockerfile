FROM ubuntu:16.04
MAINTAINER Masonite <webteam@masonite.com>
LABEL Description="Cutting-edge Node stack for Masonite, based on Ubuntu 16.04 LTS. Includes Node and MariaDB." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/opt -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql masonitedoors/lamp" \
	Version="1.0"

RUN apt-get update
RUN apt-get upgrade -y

COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

RUN apt-get install -y -qq systemd apt-utils software-properties-common build-essential language-pack-en gcc g++ make
RUN apt-get install -y zip unzip tzdata sudo
RUN apt-get install nginx -y
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN apt-get install postfix -y
RUN apt-get install git htop nano tree curl -y

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV DATE_TIMEZONE UTC
ENV TERM dumb

RUN pass=$(perl -e 'print crypt($ARGV[0], "password")' 'node'); useradd -m -p $pass node

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN npm install pm2@latest -g

RUN mkdir /opt/app
RUN mkdir /opt/logs

COPY helloworld/app.js /opt/app/app.js
COPY helloworld/package.json /opt/app/package.json
COPY run-node.sh /usr/sbin/
COPY mysql_defaults.sql /root/
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /usr/sbin/run-node.sh
RUN chown -R node:node /opt
RUN chmod -R 775 /opt
RUN pm2 startup

VOLUME /opt
VOLUME /var/log/nginx
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
VOLUME /etc/nginx

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/run-node.sh"]