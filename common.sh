#!/bin/bash

set -e 

handle_error(){
    echo "error occured at line no. $1 error command $2"

}
    
 trap 'handle_error ${LINENO} "$BASH_COMMAND" ' ERR

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "please enter the DB password:"
read -s mysql_root_password
VALIDATE(){
    if [ $1 -ne 0 ]
   then 
    echo -e "$2 ...$R failure $N"
    exit 1
   else
    echo -e "$2 ...$G success $N"
    fi
}
 check_root(){
    
    if [ $USERID -ne 0 ]
 then 
  echo "please try to run the script using root access"
  exit 1
 else 
  echo "you are a super user"
 fi

 }
 