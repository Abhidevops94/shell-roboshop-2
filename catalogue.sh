#!/bin/bash

#!/bin/bash
source ./common.sh
app_name=user
check_root
app_setup
nodejs_setup
systemd_setup
print_time

cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb client"

STATUS=$(mongosh --host mongodb.abhi84s-daws.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.abhi84s-daws.site </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into mongodb"
else
    echo -e "DATA is already loaded ... $Y SKIPPING $N"
fi

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "script is completed successfully, $Y time taken: $TOTAL_TIME $N" | tee -a $LOG_FILE
