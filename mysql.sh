#!/bin/bash

source ./common.sh
app_name=mysql
check_root

echo "please enter root password to setup"
read -s MYSQL_SQL_PASSWORD

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing Mysql server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling Mysql server"

systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "starting Mysql server"

mysql_secure_installation --set-root-pass $MYSQL_SQL_PASSWORD &>>$LOG_FILE
VALIDATE $? "setting root password"

print_time