 #!/bin/bash

 source ./common.sh
 check_root

 echo "please enter the DB password:"
 read -s "mysql_root_password"
 

 dnf module disable nodejs -y &>>LOGFILE
 VALIDATE $? "disabling default nodejs"

 dnf module enable nodejs:20 -y &>>LOGFILE
 VALIDATE $? "enabling nodejs:20 version"

 dnf install nodejs -y &>>LOGFILE
 VALIDATE $? "installing nodejs"

 id expense &>>LOGFILE
 if [ $? -ne 0 ]
 then 
   useradd expense &>>LOGFILE
   VALIDATE $? "creating a new user"
  else
    echo -e "expense user already created $Y .. SKIPPING.. $N"
  fi

  mkdir -p /app &>>LOGFILE
  VALIDATE $? "creating app directory"

 curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
 VALIDATE $? "downloading the backend code"

 cd /app 
 rm -rf /app/*
 unzip /tmp/backend.zip &>>LOGFILE
 VALIDATE $? "extracting backend code"

 npm install &>>LOGFILE
 VALIDATE $? "installing the nodejs dependencies"

 cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>LOGFILE
 VALIDATE $? "copied backend service"

 systemctl daemon-reload &>>LOGFILE
 VALIDATE $? "daemon reload"
 systemctl start backend &>>LOGFILE
 VALIDATE $? "starting backend"
 systemctl enable backend &>>LOGFILE
 VALIDATE $? "enabling backend"

 dnf install mysql -y &>>LOGFILE
 VALIDATE $? "installing mysql client"

 mysql -h db.devopsaws78.cloud -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOGFILE
 VALIDATE $? "loading schema"

 systemctl restart backend &>>LOGFILE
 VALIDATE $? "restarting backend"




