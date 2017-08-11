#!/bin/bash
lspid=`ps -A | awk '/LSProSvr/{print $1}'`
echo $lspid
kill -9 $lspid
