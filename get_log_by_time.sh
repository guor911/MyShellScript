#!/bin/bash
###################################################
#获取某个时间段日志
#byguorui
###################################################
if[[$# -lt 3]];then
echo"$0FILESTARTTIMEENDTIME"
echo"STARTTIMEandENDTIMEshouldbeinformatlike09:00:00"
echo
exit1
fi

file_name=$1
start=$2
end=$3
file_size=$(stat--format=%s$file_name)

function GetLocation
{
    echo$(ddif=$file_nameskip=$(($location/10000))ibs=10000count=12>/dev/null|sed-n"2p"|awk'{printsubstr($3,1,8)}')
}

function BinSearch
{
    low=0
    hight=$file_size
    location=0
    while[[$low -le $hight]]
    do
    mid=$((($low+$hight)/2));
    location=$mid
    tmp_time=`GetLocation`
    if[[$1=$tmp_time]]
    then
    echo$location
    break
    fi
    if[[$1<$tmp_time]]
    then
    hight=$mid
    fi
    if[[$1>$tmp_time]]
    then
    low=$mid
    fi
    done
}

start_local=`BinSearch$2`
echo $start_local
end_local=`BinSearch$3`
echo $end_local
length=$(($end_local-$start_local))
echo $length

ddif=$file_namebs=1000skip=$(($start_local/1000))count=$(($length/1000))2>/dev/null