#!/bin/bash

#$1 folder which saved monitor info
#$2 how long running the monitor

START=`date +"%Y-%m-%d %H:%M:%S"`
Sys_START=`date -d  "$START" +%s`

mydir=$1
timing=$2

times=`expr $timing / 5`
thispid=`pidof -x mymonitor.sh`
lspid=`ps -A | awk '/LSProSvrSub/{print $1}' | sed '1q'`

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
times=`expr $timing / 5`
nmon -s5 -c$times -f -m ./
pidstat -r -p $lspid 1 $2 >> "$1/mem_$lspid.txt" &
pidstat -u -p $lspid 1 $2 >> $1/cpu_$lspid.txt &
pidstat -d -p $lspid 1 $2 >> $1/IO_$lspid.txt &
pidstat -t -p $lspid >> $1/Threads_$lspid.txt &

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
