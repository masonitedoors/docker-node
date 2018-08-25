#!/bin/bash

function exportBoolean {
    if [ "${!1}" = "**Boolean**" ]; then
            export ${1}=''
    else
            export ${1}='Yes.'
    fi
}

exportBoolean LOG_STDOUT
exportBoolean LOG_STDERR

if [ $LOG_STDERR ]; then
    /bin/ln -sf /dev/stderr /var/log/nginx/error.log
else
	LOG_STDERR='No.'
fi

# stdout server info:
if [ ! $LOG_STDOUT ]; then
cat << EOB

    ▓▓▓.                       .▓▓▓
    ▓▓▓▓▓.                   .▓▓▓▓▓
    ▓▓▓▓▓▓▓.               .▓▓▓▓▓▓▓
    ▓▓▓▓'▓▓▓▓.           .▓▓▓▓'▓▓▓▓
    ▓▓▓▓ '▓▓▓▓▓.       .▓▓▓▓▓' ▓▓▓▓
    ▓▓▓▓   '▓▓▓▓▓.   .▓▓▓▓▓'   ▓▓▓▓
    ▓▓▓▓     '▓▓▓▓▓.  '▓▓▓'    ▓▓▓▓
    ▓▓▓▓     . '▓▓▓▓▓.  '      ▓▓▓▓
    ▓▓▓▓     ▓.  '▓▓▓▓▓.       ▓▓▓▓
    ▓▓▓▓     ▓▓▓.  '▓▓▓▓▓.     ▓▓▓▓
    ▓▓▓▓     ▓▓▓▓    '▓▓▓▓     ▓▓▓▓
    ▓▓▓▓     ▓▓▓▓     ▓▓▓▓     ▓▓▓▓
    ▓▓▓▓     ▓▓▓▓     ▓▓▓▓     ▓▓▓▓
    ▓▓▓▓     ▓▓▓▓     ▓▓▓▓     ▓▓▓▓
    ▓▓▓▓     ▓▓▓▓     ▓▓▓▓     ▓▓▓▓
    
    Docker image: masonitedoors/node
    https://github.com/masonitedoors/docker-node
    
    SERVER SETTINGS
    -------------------------------
    · Redirect NGINX access_log to STDOUT [LOG_STDOUT]: No.
    · Redirect NGINX error_log to STDERR [LOG_STDERR]: $LOG_STDERR
    · Log Level [LOG_LEVEL]: $LOG_LEVEL
    · Date timezone [DATE_TIMEZONE]: $DATE_TIMEZONE

EOB
else
    /bin/ln -sf /dev/stdout /var/log/nginx/access.log
fi

# Run Postfix
/usr/sbin/postfix start

if [ ! -f /root/mysql_defaults.sql ]; then
    # Run MariaDB (to set root pw)
    /usr/bin/mysqld_safe --skip-grant-tables

    # Set MariaDB/MySQL defaults
    mysql < /root/mysql_defaults.sql

    service mysql stop
    rm /root/mysql_defaults.sql
fi

# Run MariaDB
service mysql restart

# Run NGINX:
service nginx restart

# Run NODE:
cd /opt/app/
npm install
pm2 start /opt/app/app.js --name app -i 1 -e /opt/logs/app_error.log -o /opt/logs/out.log

echo "DONE"
