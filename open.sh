#!/bin/sh

# shell 中变量赋值等号两边不能有空格
file=$1;

#shell 中if语句if与[、[]与里面的语句要用空格隔开
if [ ! -f "$file" ];then
    echo "$file not exist"
    exit 0
fi

#start是MS-DOS命令，其在xp、Windows7系统下运行
#也可以"PATH/chrome.exe" "file" 的方式打开文件
start chrome "$file"
