FROM ubuntu:22.04

ENV LANG C.UTF-8

# install mysql-server, mysql-client
RUN apt-get update && \
    apt-get install -y tzdata systemctl && \
    apt-get install -y mysql-server && \
    echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get install -y mysql-client

# config mysql
RUN systemctl enable mysql && \
    service mysql start && \
    mysql -e "CREATE USER 'luling'@'%' IDENTIFIED BY '123456'; GRANT ALL PRIVILEGES ON *.* TO 'luling'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" && \
    service mysql restart && \
    mysql -u luling -p123456 -e "CREATE DATABASE IF NOT EXISTS aimemory; USE aimemory;CREATE TABLE IF NOT EXISTS main(\`id\` int not null auto_increment,\`sender\` varchar(64) not null,\`group\` varchar(64) not null,\`content\` varchar(4096) not null,\`date\` datetime(3),\`reply\` int unsigned default 0,primary key(\`id\`))ENGINE=InnoDB DEFAULT CHARSET=utf8;"

# install python3.8
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.8

# install ubuntu requirements
RUN apt-get install -y openjdk-17-jdk git pip curl openssh-server wget vim

# pull backend and install python requirements
RUN mkdir /home/luling-backend && \
    cd /home/luling-backend && \
    git clone https://github.com/huan-yp/luling-backend.git /home/luling-backend && \
    pip install -r /home/luling-backend/requirement.txt
