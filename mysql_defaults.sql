use mysql;
update user SET password=PASSWORD("root") where User='root';
create user 'node'@'localhost' IDENTIFIED BY 'node';
update user SET password=PASSWORD("node") where User='node';
GRANT ALL PRIVILEGES ON *.* TO 'node'@'localhost';
flush privileges;