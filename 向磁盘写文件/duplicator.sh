#!/usr/bin/bash

#运行本脚本前请先运行脚本 initializer.sh
#本脚本用于不断复制文件，直到给出的参数阈值超过当前磁盘空间利用率
#输入参数：磁盘空间使用率阈值

#函数：打印脚本使用说明
function usage()
{
    echo "Usage: ./duplicator [threshold]"
    echo "threshold is an integer in the range of [1,99]"
    echo "*Run initializer.sh before run this script"
    exit 0
}

#脚本有且只有一个输入
if [ "$#" -ne 1 ]; then
    echo "脚本应有且只有一个输入"
    usage
fi

#脚本的输入必须为5-95之间的正整数
threshold=`echo $1 | bc`
if [ "$threshold" -lt 5 -o "$threshold" -gt 95 ]; then
    echo "脚本的输入必须为5-95之间的正整数"
    usage
fi

#目录TestDir必须存在
if [ ! -d ./TestDir ]; then
    echo "缺少目录 TestDir"
    usage
fi

#文件TestDir/template必须存在
if [ ! -f ./TestDir/template ]; then
    echo "缺少文件 TestDir/template"
    usage
fi

cd TestDir

#复制文件，超过输入的阈值为止
i=0
while [ true ]; do
    cur=`df -h | grep /dev/sda3 | awk '{printf substr($5,1,length($5)-1)}'`
    echo "Current usage: $cur | Object usage: $threshold"
    if [[ "$cur" -gt "$threshold" ]]; then
        break;
    fi
    cp template $i
    echo " $i Duplication complete!"
    ((i++))
done

cd .. #TestDir

echo "Script finished!"

exit 0
