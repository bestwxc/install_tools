#!/bin/bash
source config.sh
etc_dir=/etc/keepalived
if [ ! -d "$etc_dir" ];then
	mkdir -p $etc_dir
else
	echo "$etc_dir exists.please check it!"
	echo "tips:backup or remove it!"
	exit -1
fi

if [ ! -f "/usr/local/bin/redis-cli" ];then
	ln -s $install_dir/$package_ver/bin/redis-cli /usr/local/bin
else
	echo "/usr/local/bin/redis-cli exists.please check it."
	echo "tips:backup or remove it."
	rm -rf $etc_dir
	exit -1
fi


rm -rf $tmp_dir
mkdir -p $tmp_dir

cp -rvf $script_dir/config_keepalived_templet/* $tmp_dir

sed -i "s/RE_VI_NAME/$slave_vi_name/g" $tmp_dir/keepalived.conf
sed -i "s/RE_ROUTER_ID/$virtual_router_id/g" $tmp_dir/keepalived.conf
sed -i "s/RE_PRIORITY/$slave_redis_priority/g" $tmp_dir/keepalived.conf
sed -i "s/RE_VIP/$virtual_ip/g" $tmp_dir/keepalived.conf
sed -i "s/RE_INTERFACE/$slave_interface/g" $tmp_dir/keepalived.conf
sed -i "s/RE_STATE/$slave_state/g" $tmp_dir/keepalived.conf

sed -i "s/RE_PORT/$slave_redis_port/g" $tmp_dir/scripts/*
sed -i "s/RE_PASS/$slave_redis_pass/g" $tmp_dir/scripts/*
sed -i "s/RE_SLAVE_IP/$master_redis_ip/g" $tmp_dir/scripts/*
sed -i "s/RE_SLAVE_PORT/$master_redis_port/g" $tmp_dir/scripts/*
alias cp=cp
cp -rvf $tmp_dir/* $etc_dir
chmod u+x $etc_dir/scripts/*
rm -rf $tmp_dir





