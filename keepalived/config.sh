#!/bin/bash
export script_dir=$(cd `dirname $0`;pwd)
export install_dir=/opt/software
#export tmp_dir=$script_dir/tmp
export package_dir=$(cd $script_dir/../packages;pwd)
export package_ver=keepalived-1.2.16
export package_name=$package_ver.tar.gz

