#!/bin/bash

source config.sh

keepalived_dir=$install_dir/$package_ver

echo "please check the below info:"
echo "install dir is:$keepalived_dir"
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

if [ ! -f "$package_dir/$package_name" ];then
	echo "redis package not exists,please put the package in $package_dir."
	exit -1
else
	tar -xvf $package_dir/$package_name -C $install_dir
	cd $install_dir/$package_ver
	./configure
	make
	make install
	alias cp=cp
	cp -rf /usr/local/etc/rc.d/init.d/keepalived /etc/init.d/
	cp -rf /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
	chmod +x /etc/init.d/keepalived
	chkconfig --add keepalived
	ln -s /usr/local/sbin/keepalived /usr/sbin
	echo "finish install setup keepalived."
fi
