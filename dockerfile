FROM ubuntu:22.04

# install miniconda3
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/opt/conda/bin:${PATH}"

# install mysql8 and config a root with password 123456
# then create a database and create the table
RUN apt-get install -y mysql-server mysql-client && \
    systemctl enable mysql && \
    service mysql start && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '123456' WITH GRANT OPTION;" && \
    service mysql restart && \
    mysql -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS aimemory; USE aimemory; CREATE TABLE IF NOT EXISTS main(`id` int not null auto_increment,`sender` varchar(64) not null,`group` varchar(64) not null,`content` varchar(4096) not null,`date` datetime(3),`reply` int unsigned default 0,primary key(`id`))ENGINE=InnoDB DEFAULT CHARSET=utf8;"

# install ohter requirements
RUN apt-get install -y openjdk-17-jdk python3.8 git pip curl

# pull backend and install python requirements
RUN apt-get install -y git && \
    git clone https://github.com/huan-yp/luling-backend.git /home/luling-backend && \
    conda activate base && \
    pip install -r /home/luling-backend/requirements.txt