#!/bin/bash

source ./common.sh
app_name=shipping
check_root
app_setup
maven_setup
systemd_setup

echo "please enter root password to setup"
read -s MYSQL_SQL_PASSWORD

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing mysql"

mysql -h mysql.abhi84s-daws.site -u root -p$MYSQL_SQL_PASSWORD -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.abhi84s-daws.site -uroot -p$MYSQL_SQL_PASSWORD < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.abhi84s-daws.site -uroot -p$MYSQL_SQL_PASSWORD < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.abhi84s-daws.site -uroot -p$MYSQL_SQL_PASSWORD < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "Loading data into mysql"
else
    echo -e "data is already loaded to mysql ... $Y SKIPPING $N"
fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "restarting shipping"

print_time