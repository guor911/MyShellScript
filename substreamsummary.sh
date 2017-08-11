#!/bin/bash

AS_log=AS-RTP-SVR-2017-04-08.log
LS_log=LSProSvrMain_20581-2017-04-07.log
SS_log=wowzastreamingengine_access.log

function hd(){
    if[[$1 =~ 'AS']];then
        if[-f $1];then
            as_rec_ctr=`cat $AS_log | grep '<streamControl'|wc -l`
            as_rec_stop=`cat $AS_log | grep '<streamStop'|wc -l`
            echo '#   as rec streamctr: $as_rec'
            echo '#   as rec streamstop: $as_rec_stop'
        else
            exit 1
        fi
    elif[[$1 =~ 'LS']];then
        if[-f $1];then
            as_rec_ctr=`cat $LS_log | grep '<streamControl'|wc -l`
            as_rec_stop=`cat $LS_log | grep '<streamStop'|wc -l`
            echo '#   ls rec streamctr: $as_rec'
            echo '#   ls rec streamstop: $as_rec_stop'
        else
            exit 1
        fi
    elif[[$1 =~ 'wowza']];then
        echo 'wowza handle...'
    fi
}

hd $AS_log
hd $LS_log

