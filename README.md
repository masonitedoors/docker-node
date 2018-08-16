masonitedoors/node
==========

![docker_logo](https://raw.githubusercontent.com/masonitedoors/docker-node/master/docker_139x115.png)![docker_masonitedoors_logo](https://raw.githubusercontent.com/masonitedoors/docker-node/master/docker_masonitedoors_161x115.png)

[![Docker Pulls](https://img.shields.io/docker/pulls/masonitedoors/node.svg?style=plastic)](https://hub.docker.com/r/masonitedoors/node/)
[![Docker Build Status](https://img.shields.io/docker/build/masonitedoors/node.svg?style=plastic)](https://hub.docker.com/r/masonitedoors/node/builds/)
[![](https://images.microbadger.com/badges/image/masonitedoors/node.svg)](https://microbadger.com/images/masonitedoors/node "masonitedoors/node")

This Docker container implements a Ubuntu 16.04 Node stack behind a nginx proxy. Includes support for [npm](https://www.npmjs.com/) package managers and a Postfix service to allow sending emails.

Includes the following components:

 * Ubuntu 16.04 LTS Xenial Xerus base image.
 * Nginx HTTP Server 1.10.3
 * MariaDB 10.0
 * Postfix 2.11
 * Node 8.11.3
 * Development tools
	* git
	* npm / nodejs
	* vim
	* tree
	* nano
	* curl
	* htop
	* unzip

Installation from [Docker registry hub](https://registry.hub.docker.com/u/masonitedoors/node/).
----

You can download the image using the following command:

```bash
docker pull masonitedoors/node
```

Environment variables
----

This image uses environment variables to allow the configuration of some parameteres at run time:

* Variable name: LOG_STDOUT
* Default value: Empty string.
* Accepted values: Any string to enable, empty string or not defined to disable.
* Description: Output NGINX access log through STDOUT, so that it can be accessed through the [container logs](https://docs.docker.com/reference/commandline/logs/).

----

* Variable name: LOG_STDERR
* Default value: Empty string.
* Accepted values: Any string to enable, empty string or not defined to disable.
* Description: Output NGINX error log through STDERR, so that it can be accessed through the [container logs](https://docs.docker.com/reference/commandline/logs/).

----

* Variable name: LOG_LEVEL
* Default value: warn
* Accepted values: debug, info, notice, warn, error, crit, alert, emerg
* Description: Value for NGINX.

----

* Variable name: DATE_TIMEZONE
* Default value: UTC
* Accepted values: Any of timezones
* Description: Set default timezone and sets MariaDB as well.

----

* Variable name: TERM
* Default value: dumb
* Accepted values: dumb
* Description: Allow usage of terminal programs inside the container, such as `mysql` or `nano`.

Exposed port and volumes
----

The image exposes ports `80`,`443`,`3306`,`22`,`25`,`143`,`993`,`110`,`995`, and exports four volumes:

* `/var/log/nginx`, containing Nginx log files.
* `/var/log/mysql` containing MariaDB log files.
* `/opt/`, used as Node app location.
* `/var/lib/mysql`, where MariaDB data files are stores.

The user and group owner id for the node directory `/opt/` are both 33 (`uid=33(node) gid=33(node) groups=33(node)`).

The user and group owner id for the MariaDB directory `/var/log/mysql` are 105 and 108 repectively (`uid=105(mysql) gid=108(mysql) groups=108(mysql)`).

Use cases
----

#### Create a temporary container for testing purposes:

```
	docker run -i -t --rm masonitedoors/node bash
```

#### Create a temporary container to debug a web app:

```
	docker run --rm -p 8080:80 -e LOG_STDOUT=true -e LOG_STDERR=true -e LOG_LEVEL=debug -v /my/data/directory:/opt masonitedoors/node
```

#### Create a container linking to another [MySQL container](https://registry.hub.docker.com/_/mysql/):

```
	docker run -d --link my-mysql-container:mysql -p 8080:80 -v /my/data/directory:/opt -v /my/logs/directory:/var/log/nginx --name my-node-container masonitedoors/node
```

#### Get inside a running container and open a MariaDB console:

```
	docker exec -i -t my-node-container bash
	mysql -u root
```

Default Users
----
SSH: root | root
SSH: node | node
MySQL: root | root
MySQL: node | node