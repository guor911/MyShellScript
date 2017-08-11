#!/usr/bin/bash

function initializer(){
    #本脚本用于初始化工作，创建文件夹TestDir并写入一个大小为1G的目录
    #创建文件TestDir
    if [ -x "./TestDir" ]; then
        echo "TestDir was exist, need delete first, deleting..."
        rm -rf TestDir
        echo "deleted."
    fi
    
    echo "TestDir is not found, need create first, creating..."
    mkdir TestDir
    echo "created."
    
    cd TestDir
    echo "create testing data named template which size is 1G."
    dd if=/dev/zero of=template bs=1M count=1024
    echo "create template success..."
    pwd .
    du -sh .
    cd ..
    exit 0
}

function duplicator(){
    #运行本脚本前请先运行脚本 initializer.sh
    #本脚本用于不断复制文件，直到给出的参数阈值超过当前磁盘空间利用率
    #输入参数：磁盘空间使用率阈值

    #函数：打印脚本使用说明
    #Usage: ./duplicator [threshold]
    #"threshold is an integer in the range of [1,99]
    #*Run initializer.sh before run this script


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
}

function clear(){
    #本脚本用于清空脚本initializer.sh和duplicator.sh留下的痕迹
    #检查文件是否存在
    if [ ! -x "./TestDir" ]; then
        echo "文件 ./TestDir 不存在，无需清除"
        exit 0
    fi
    #用户确认后清除文件
    echo "真的要清除全部数据吗？ (y/n)"
    read input
    case "$input" in
        y* | Y* )
            rm -rf ./TestDir
            echo "数据删除完毕";;
        n* | N* )
            echo "放弃删除数据";;
        * )
            echo "输入未识别";;
    esac
    exit 0
}

initializer()
duplicator() $1
clear()