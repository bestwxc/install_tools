#!/bin/bash

source config.sh

redis_dir=$install_dir/$package_ver

echo "please check the below info:"
echo "install dir is:$redis_dir"
echo "package dir is:$package_dir"
echo "package file name:$package_name"
echo "(yes/no)"
read cw
case $cw in
	yes)
		echo "the setup start."	
	;;
	no)
		echo "the setup is cancelled."
		exit -1
	;;
	*)
		echo "please type yes or no."
		exit -1
	;;
esac

if [ -d "$redis_dir" ];then
	echo "the floder $redis_dir exists,please check the dir."
	echo "tips:backup or remove the folder"
	exit -1
fi

if [ ! -f "$package_dir/$package_name" ];then
	echo "redis package not exists,please put the package in $package_dir."
	exit -1
else
	rm -rf $tmp_dir
	mkdir -p $tmp_dir
	tar -xvf $package_dir/$package_name -C $tmp_dir
	cd $tmp_dir/$package_ver
	make
	#make test
	make PREFIX=$redis_dir install
	mkdir -p $redis_dir/conf
	cp redis.conf $redis_dir/conf/redis.conf.default
	rm -rf $tmp_dir
	#ln -s $redis_dir $install_dir/redis
	if [ ! -f "/usr/local/bin" ];then
		ln -s $redis_dir/bin/redis-cli /usr/local/bin
	fi
	echo "finish install setup redis"
fi
