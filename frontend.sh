#!/bin/bash

source ./common.sh
check_root

dnf module list nginx &>>$LOG_FILE
VALIDATE $? "listing ngnix module"

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "Disabling ngnix module"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enabling ngnix:1.24 module"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing ngnix module"

systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Enabled and starting ngnix service"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing the default content that web server is serving"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "Downloading the frontend content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping the frontend content"

rm -rf /etc/nginx/nginx.conf
VALIDATE $? "Remove default nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying nginx conf file"

systemctl restart nginx
VALIDATE $? "Restarting nginx"

print_time

