#!/usr/bin/bash

#本脚本用于初始化工作，创建文件夹TestDir并写入一个大小为100M的目录

#创建文件TestDir
if [ -x "./TestDir" ]; then
    rm -rf TestDir
fi
mkdir TestDir
cd TestDir

dd if=/dev/zero of=template bs=1M count=1024

pwd .
du -sh .

cd ..

exit 0
