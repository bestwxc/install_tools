#!/bin/bash
REDISCLI="/usr/local/bin/redis-cli"
LOGFILE="/var/log/keepalived-redis-state.log"
send=`date '+%Y-%m-%d %H:%M:%S'`
echo $send >> $LOGFILE
echo "[master]" >> $LOGFILE
date >> $LOGFILE
echo "Being master...." >> $LOGFILE 2>&1
echo "Run SLAVEOF cmd ..." >> $LOGFILE
$REDISCLI -p RE_PORT -a RE_PASS SLAVEOF RE_SLAVE_IP  RE_SLAVE_PORT >> $LOGFILE  2>&1
sleep 10 #
echo "Run SLAVEOF NO ONE cmd ..." >> $LOGFILE
$REDISCLI -p RE_PORT -a RE_PASS SLAVEOF NO ONE >> $LOGFILE 2>&1
