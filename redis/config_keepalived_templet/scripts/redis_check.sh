#!/bin/bash  
ALIVE=`/usr/local/bin/redis-cli -p RE_PORT -a RE_PASS PING`  
LOGFILE="/var/log/keepalived-redis-state.log"
echo $send >> $LOGFILE
if [ "$ALIVE" == "PONG" ]; then 
echo $ALIVE  
exit 0  
else 
echo $ALIVE  
exit 1  
fi
