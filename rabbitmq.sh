#!/bin/bash

source ./common.sh
app_name=rabbitmq
check_root

echo "please enter rabbitmq password to setup"
read -s RABBITMQ_PASSWORD

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Copying rebbitmq repo"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "installing rebbitmq"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "enabling rebbitmq"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "starting rebbitmq"

id roboshop
if [ $? -ne 0 ]
then
    rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD &>>$LOG_FILE
    VALIDATE $? "Adding application User"
else
    echo -e "system user roboshop already created ...$Y SKIPPING $N"
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
VALIDATE $? "setting permission for roboshop"

print_time