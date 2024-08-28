#!/bin/bash

 source ./common.sh
 check_root

 dnf install nginx -y &>>LOGFILE
 #VALIDATE $? "installing nginx"

 systemctl enable nginx &>>LOGFILE
 #VALIDATE $? "enabling nginx"

 systemctl start nginx &>>LOGFILE
 #VALIDATE $? "starting nginx"

 rm -rf /usr/share/nginx/html/* &>>LOGFILE
 #VALIDATE $? "removing existing content"

 curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
 #VALIDATE $? "downloading frontend code"

 cd /usr/share/nginx/html &>>LOGFILE
 unzip /tmp/frontend.zip &>>LOGFILE

 cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>LOGFILE
 #VALIDATE $? "copied expense conf"

 systemctl restart nginx &>>LOGFILE
 #VALIDATE $? "restarting nginx"
 