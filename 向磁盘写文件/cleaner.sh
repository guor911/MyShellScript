#!/usr/bin/bash

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
