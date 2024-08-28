#!/bin/bash

source ./common.sh

check_root

echo "please enter the DB password:"
read -s "mysql_root_password"

  dnf install mysql-server -y &>>LOGFILE
  #VALIDATE $? "installing mysql server"   , made it comment to check if VALIDATE line alter by handle_error & trap command

  systemctl enable mysqld &>>LOGFILE
  #VALIDATE $? "enabiling mysql server"

  systemctl start mysqld &>>LOGFILE
  #VALIDATE $? "starting mysql server"

  #mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
  #VALIDATE $? "mysql root password setup"

  # Below code will be useful for idempotent nature 
 mysql -h db.devopsaws78.cloud -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>LOGFILE
 if [ $? -ne 0 ]
  then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>LOGFILE
    #VALIDATE $? "setup mysql root password"
   else
     echo -e "mysql root password is already setup $Y SKIPPING $N"  
   fi

