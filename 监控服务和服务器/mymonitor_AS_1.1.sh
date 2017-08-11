#!/bin/bash

#$1 folder which saved monitor info
#$2 how long running the monitor(sec)

START=`date +"%Y-%m-%d %H:%M:%S"`
Sys_START=`date -d  "$START" +%s`

mydir=$1
timing=$2

times=`expr $timing / 5`
thispid=`pidof -x mymonitor.sh`
mainpid=`ps -A | awk '/AS-RTP-SVR/{print $1}' | sed '1q'`
subpid=`ps -A | awk '/AS-RTP-SVR-SUB/{print $1}' | sed '1q'`

existHandle(){
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

myexit(){
    nmonpid=`ps -ef | grep "nmon -s5" | grep -v grep | awk '{print $2}'`
    echo "nmon_pid: $nmonpid"
    kill -9 $nmonpid
    #kill -9 $thispid
    echo Ending...
    echo "******************************"
    echo ENDTIME: $CURTIME
    echo INTERVAL: $interval"(s)"
    echo "******************************"
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
echo "mainpid: $mainpid"
echo "subpid: $subpid"
echo "TotalSecond: $2"
echo "******************************"

nmon -s5 -c$times -f -m ./
pidstat -r -p $mainpid 1 $2 >> $1/mem_$mainpid.txt &
pidstat -u -p $mainpid 1 $2 >> $1/cpu_$mainpid.txt &
pidstat -d -p $mainpid 1 $2 >> $1/IO_$mainpid.txt &
pidstat -t -p $mainpid >> $1/Threads_$mainpid.txt &
pidstat -r -p $subpid 1 $2 >> $1/mem_$subpid.txt &
pidstat -u -p $subpid 1 $2 >> $1/cpu_$subpid.txt &
pidstat -d -p $subpid 1 $2 >> $1/IO_$subpid.txt &
pidstat -t -p $subpid >> $1/Threads_$subpid.txt &

while [ "$interval" != "$2" ];do
    CURTIME=`date +"%Y-%m-%d %H:%M:%S"`
    Sys_CUR=`date -d "$CURTIME" +%s`
    interval=`expr $Sys_CUR - $Sys_START`
    trap "existHandle;myexit;exit" INT 
    sleep 1 
done

existHandle

echo Ending...
echo "******************************"
echo ENDTIME: $CURTIME
echo INTERVAL: $interval"(s)"
echo "******************************"

myexit
exit
