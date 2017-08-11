#!/bin/bash

#***************************************
#monitor LSProSvrSub/AS-RTP-SVR-SUB pid script
#$1 folder which saved monitor info
#$2 how long running the monitor
#eg. monitor one hour and save the data in 1_guorui folder
#run: ./mymonitor.sh 1_guorui 3600
#***************************************

START=`date +"%Y-%m-%d %H:%M:%S"`
Sys_START=`date -d  "$START" +%s`

mydir=$1
timing=$2

times=`expr $timing / 5`
thispid=`pidof -x mymonitor_IAC.sh`
IACpid=`ps -A | awk '/IACSvr/{print $1}' | grep -v tail | grep -v grep |sed '1q'`
IAMpid=`ps -A | awk '/IAM/{print $1}' |grep -v tail |grep -v grep | sed '1q'`

exitHandle(){
    echo "---------------handling-----------------"
    filelist=$(ls -l $mydir/* | awk '{print $NF}')
    for file in $filelist;do
        if [ -f $file ];then
            echo $file
            cat $file | sed -e '/^$/d' > $file""_new
            # sed -i '1d' $file""_new
        else
           continue
        fi
    done
}


if [ -d "$1" ];then
    echo $1 have exist,will be moved and create new
    mv $1 $1_bak_$(date +%Y%m%d_%H%M%S)
    mkdir $1
else
    echo Create new folder $1
    mkdir $1
fi

echo "******************************"
echo STARTTIME: $START
echo "SaveDir: $1"
echo "pid: $lspid"
echo "TotalSecond: $2"
echo "******************************"
#times=`expr $timing / 5`
nmon -s5 -c$times -f -m ./
pidstat -r -p $IACpid 1 $2 >> "$1/IAC_mem_$IACpid.txt" &
pidstat -u -p $IACpid 1 $2 >> $1/IAC_cpu_$IACpid.txt &
pidstat -d -p $IACpid 1 $2 >> $1/IAC_IO_$IACpid.txt &

pidstat -r -p $IAMpid 1 $2 >> "$1/IAM_mem_$IAMpid.txt" &
pidstat -u -p $IAMpid 1 $2 >> $1/IAM_cpu_$IAMpid.txt &
pidstat -d -p $IAMpid 1 $2 >> $1/IAM_IO_$IAMpid.txt &


myexit(){
    nmonpid=`ps -ef | grep "nmon -s5" | grep -v grep | awk '{print $2}'`
    echo "nmon_pid: $nmonpid"
    kill -9 $nmonpid
   # kill -9 $thispid
}

while [ "$interval" != "$2" ];do
    CURTIME=`date +"%Y-%m-%d %H:%M:%S"`
    Sys_CUR=`date -d  "$CURTIME" +%s`
    interval=`expr $Sys_CUR - $Sys_START`
    trap "exitHandle;myexit;exit" INT 
    sleep 1 
done

exitHandle

echo Ending...
echo "******************************"
echo ENDTIME: $CURTIME
echo INTERVAL: $interval"(s)"
echo "******************************"

myexit
exit
