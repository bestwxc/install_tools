#! /bin/bash
# System optimization script

export LANG=C
echo " "

SELINUXSTATUS=`getenforce`
UNAME_I=`uname -i`
ULIMIT_U=`ulimit -u`
ULIMIT_N=`ulimit -n`
IS_ULIMIT=`cat /etc/profile|grep ulimit|wc -l`
ULIMIT_U_SUM=`cat /etc/security/limits.conf|grep -v ^#|grep nproc|wc -l`
ULIMIT_N_SUM=`cat /etc/security/limits.conf|grep -v ^#|grep nofile|wc -l`
IS_ULIMITS=`cat /etc/security/limits.d/90-nproc.conf|grep 1024|grep -v ^#|wc -l`
FS_MAX=`cat /proc/sys/fs/file-max`
IS_FS_MAX=`cat /etc/sysctl.conf|grep fs.file-max|wc -l`
WMEM_1=`cat /proc/sys/net/ipv4/tcp_wmem|awk '{print $1}'`
WMEM_2=`cat /proc/sys/net/ipv4/tcp_wmem|awk '{print $2}'`
WMEM_3=`cat /proc/sys/net/ipv4/tcp_wmem|awk '{print $3}'`
IS_WMEM=`cat /etc/sysctl.conf|grep wmem|wc -l`
RMEM_1=`cat /proc/sys/net/ipv4/tcp_rmem|awk '{print $1}'`
RMEM_2=`cat /proc/sys/net/ipv4/tcp_rmem|awk '{print $2}'`
RMEM_3=`cat /proc/sys/net/ipv4/tcp_rmem|awk '{print $3}'`
IS_RMEM=`cat /etc/sysctl.conf|grep rmem|wc -l`
IP_PORT_1=`cat /proc/sys/net/ipv4/ip_local_port_range|awk '{print $1}'`
IP_PORT_2=`cat /proc/sys/net/ipv4/ip_local_port_range|awk '{print $2}'`
IS_IP_PORT=`cat /etc/sysctl.conf|grep ip_local_port_range|wc -l`
TIMESTAMPS=`cat /proc/sys/net/ipv4/tcp_timestamps`
IS_TIMESTAMPS=`cat /etc/sysctl.conf|grep tcp_timestamps|wc -l`
REUSE=`cat /proc/sys/net/ipv4/tcp_tw_reuse`
IS_REUSE=`cat /etc/sysctl.conf|grep tcp_tw_reuse|wc -l`
RECYCLE=`cat /proc/sys/net/ipv4/tcp_tw_recycle`
IS_RECYCLE=`cat /etc/sysctl.conf|grep tcp_tw_recycle|wc -l`
TIMEOUT=`cat /proc/sys/net/ipv4/tcp_fin_timeout`
IS_TIMEOUT=`cat /etc/sysctl.conf|grep tcp_fin_timeout|wc -l`
SCALING=`cat /proc/sys/net/ipv4/tcp_window_scaling`
IS_SCALING=`cat /etc/sysctl.conf|grep tcp_window_scaling|wc -l`
SACK=`cat /proc/sys/net/ipv4/tcp_sack`
IS_SACK=`cat /etc/sysctl.conf|grep tcp_sack|wc -l`


# Check SELinux Status,and optimization

if [ $SELINUXSTATUS = 'Disabled' ];then
	echo -e "The SELinux is $SELINUXSTATUS ! \033[32mGood !!\033[0m"
else
	echo -e "The SELinux is $SELINUXSTATUS !"
        echo -e "The SELinux is ptimizing.........."
        sleep 1
        setenforce 0
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
        echo -e "\033[32mSELinux\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1



# Optimization Iptables

echo -e "iptables is optimizing.........."
sleep 1
service iptables stop
chkconfig iptables off
echo -e "\033[32miptables\033[0m , Optimization \033[32mSuccess !!\033[0m"
echo " "
sleep 1


# Check limits.conf,and optimization

if [ $UNAME_I = 'x86_64' ];then
        if [ $ULIMIT_N = '1048576' ];then
                echo -e "The open files is $ULIMIT_N ! \033[32mGood !!\033[0m"
        else
                echo -e "open files is optimizing.........."
		sleep 1
		if [ $ULIMIT_N_SUM = '0' ];then
                        echo "* soft nofile 1048576" >> /etc/security/limits.conf
                        echo "* hard nofile 1048576" >> /etc/security/limits.conf
                else
                        sed -i "s/$ULIMIT_N/1048576/g" /etc/security/limits.conf
                fi
		echo -e "\033[32mopen files\033[0m , Optimization \033[32mSuccess !!\033[0m"
        fi
else
        if [ $ULIMIT_N = '65535' ];then
                echo -e "The open files is $ULIMIT_N ! \033[32mGood !!\033[0m"
        else
		echo -e "open files is optimizing.........."
                sleep 1
		if [ $ULIMIT_N_SUM = '0' ];then
                        echo "* soft nofile 65535" >> /etc/security/limits.conf
                        echo "* hard nofile 65535" >> /etc/security/limits.conf
                else
                        sed -i "s/$ULIMIT_N/65535/g" /etc/security/limits.conf
                fi
		echo -e "\033[32mopen files\033[0m , Optimization \033[32mSuccess !!\033[0m"
        fi
fi
echo " "
sleep 1

if [ $ULIMIT_U = '65535' ];then
        echo -e "The max user processes is $ULIMIT_U ! \033[32mGood !!\033[0m"
else
	echo -e "max user processes is optimizing.........."
        sleep 1
	if [ $ULIMIT_U_SUM = '0' ];then
                echo "* soft nproc 65535" >> /etc/security/limits.conf
                echo "* hard nproc 65535" >> /etc/security/limits.conf
        else
                sed -i "s/$ULIMIT_U/65535/g" /etc/security/limits.conf
        fi
	echo -e "\033[32mmax user processes\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $IS_ULIMIT != '0' ];then
	sed -i "/ulimit/d" /etc/profile
fi
echo "ulimit -n 1048576" >> /etc/profile
source /etc/profile
echo -e "\033[32m/etc/profile\033[0m , Optimization \033[32mSuccess !!\033[0m"
echo " "
sleep 1

# Check /etc/securitry/limits.d/90-nproc.conf,and optimization

if [ $IS_ULIMITS = '0' ];then
	echo -e "The 90-nproc.conf has been optimized ! \033[32mGood !!\033[0m"
else
	echo -e "/etc/security/limits.d/90-nproc.conf is optimizing.........."
	sed -i "s/*/# */g" /etc/security/limits.d/90-nproc.conf
	echo -e "\033[32m/etc/security/limits.d/90-nproc.conf\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

# Check sysctl.conf,and optimization

modprobe bridge
echo "modprobe bridge" >> /etc/rc.local

if [ $FS_MAX = '1048576' ];then
        echo -e "The fs.file-max is $FS_MAX ! \033[32mGood !!\033[0m"
else
	echo -e "max user processes is optimizing.........."
        if [ $IS_FS_MAX = '0' ];then
                echo "fs.file-max = 1048576" >> /etc/sysctl.conf
        else
                sed -i "s/$FS_MAX/1048576/g" /etc/sysctl.conf
        fi
	echo -e "\033[32mfs.file-max\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $RMEM_1 = '4096' ] && [ $RMEM_2 = '4096' ] && [ $RMEM_3 = '16777216' ];then
        echo -e "The net.ipv4.tcp_rmem is 4096 4096 16777216 ! \033[32mGood !!\033[0m"
else
	echo -e "net.ipv4.tcp_rmem is optimizing.........."
        if [ $IS_RMEM != '0' ];then
                sed -i "/rmem/d" /etc/sysctl.conf
        fi
        echo "net.ipv4.tcp_rmem = 4096 4096 16777216" >> /etc/sysctl.conf
        echo -e "\033[32mnet.ipv4.tcp_rmem\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $WMEM_1 = '4096' ] && [ $WMEM_2 = '4096' ] && [ $WMEM_3 = '16777216' ];then
	echo -e "The net.ipv4.tcp_wmem is 4096 4096 16777216 ! \033[32mGood !!\033[0m"
else
	echo -e "net.ipv4.tcp_wmem is optimizing.........."
        if [ $IS_WMEM != '0' ];then
                sed -i "/wmem/d" /etc/sysctl.conf
        fi
        echo "net.ipv4.tcp_wmem = 4096 4096 16777216" >> /etc/sysctl.conf
        echo -e "\033[32mnet.ipv4.tcp_wmem\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $IP_PORT_1 = '1024' ] && [ $IP_PORT_2 = '65535' ];then
        echo -e "The net.ipv4.ip_local_port_range is 1024 65535 ! \033[32mGood !!\033[0m"
else
	echo -e "net.ipv4.ip_local_port_range is optimizing.........."
        if [ $IS_IP_PORT != '0' ];then
                sed -i "/ip_local_port_range/d" /etc/sysctl.conf
        fi
        echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf
        echo -e "\033[32mnet.ipv4.ip_loacl_port_range\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $TIMESTAMPS = '1' ];then
        echo -e "The net.ipv4.tcp_timestamps is $TIMESTAMPS ! \033[32mGood !!\033[0m"
else
        echo -e "net.ipv4.tcp_timestamps is optimizing.........."
        if [ $IS_TIMESTAMPS = '0' ];then
                echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf
        else
                sed -i "s/$TIMESTAMPS/1/g" /etc/sysctl.conf
        fi
        echo -e "\033[32mnet.ipv4.tcp_timestamps\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $TIMEOUT = '30' ];then
        echo -e "The net.ipv4.tcp_fin_timeout is $TIMEOUT ! \033[32mGood !!\033[0m"
else
        echo -e "net.ipv4.tcp_fin_timeout is optimizing.........."
        if [ $IS_TIMEOUT = '0' ];then
                echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
        else
                sed -i "s/$TIMEOUT/30/g" /etc/sysctl.conf
        fi
        echo -e "\033[32mnet.ipv4.tcp_fin_timeout\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $REUSE = '1' ];then
        echo -e "The net.ipv4.tcp_tw_reuse is $REUSE ! \033[32mGood !!\033[0m"
else
        echo -e "net.ipv4.tcp_tw_reuse is optimizing.........."
        if [ $IS_REUSE = '0' ];then
                echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
        else
                sed -i "s/$REUSE/1/g" /etc/sysctl.conf
        fi
        echo -e "\033[32mnet.ipv4.tcp_tw_reuse\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $RECYCLE = '1' ];then
        echo -e "The net.ipv4.tcp_tw_recycle is $RECYCLE ! \033[32mGood !!\033[0m"
else
        echo -e "net.ipv4.tcp_tw_recycle is optimizing.........."
        if [ $IS_RECYCLE = '0' ];then
                echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
        else
                sed -i "s/$RECYCLE/1/g" /etc/sysctl.conf
        fi
        echo -e "\033[32mnet.ipv4.tcp_tw_recycle\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $SCALING = '1' ];then
        echo -e "The net.ipv4.tcp_window_scaling is $SCALING ! \033[32mGood !!\033[0m"
else
        echo -e "net.ipv4.tcp_window_scaling is optimizing.........."
        if [ $IS_SCALING = '0' ];then
                echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
        else
                sed -i "s/$SCALING/1/g" /etc/sysctl.conf
        fi
        echo -e "\033[32mnet.ipv4.tcp_window_scaling\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

if [ $SACK = '1' ];then
        echo -e "The net.ipv4.tcp_sack is $SACK ! \033[32mGood !!\033[0m"
else
        echo -e "net.ipv4.tcp_sack is optimizing.........."
        if [ $IS_SACK = '0' ];then
                echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
        else
                sed -i "s/$SACK/1/g" /etc/sysctl.conf
        fi
        echo -e "\033[32mnet.ipv4.tcp_sack\033[0m , Optimization \033[32mSuccess !!\033[0m"
fi
echo " "
sleep 1

sysctl -p 1>/dev/null
echo -e "\033[32mSystem Optimization Successfully !\033[0m"
echo -e "\033[32mYou must restart this computer for the changes to take effect !\033[0m"

