#!/bin/bash

#configuration for setting up redis.
export script_dir=$(cd `dirname $0`;pwd)
echo $script_dir
export install_dir=/opt/software
export tmp_dir=$script_dir/tmp
export package_dir=$(cd $script_dir/../packages;pwd)
export package_ver=redis-3.2.8
export package_name=$package_ver.tar.gz

#configuration for redis's keepalived.
#if not use keepalived,please skip them.
#common
export virtual_router_id=51
export virtual_ip=192.168.91.133
#master
export master_state=MASTER
export master_vi_name=VI_1
export master_redis_ip=192.168.91.131
export master_redis_port=6379
export master_redis_pass=123456
#should gt slave_redis_priority
export master_redis_priority=101
#use 'ip -a' or 'ifconfig'
export master_interface=eth1
#slave
export slave_state=BACKUP
export slave_vi_name=VI_2
export slave_redis_ip=192.168.91.132
export slave_redis_port=6379
export slave_redis_pass=123456
#should gt slave_redis_priority
export slave_redis_priority=100
#use 'ip -a' or 'ifconfig'
export slave_interface=eth2

