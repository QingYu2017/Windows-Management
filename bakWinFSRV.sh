#!/bin/bash 
#Auth:Qing.Yu
#Mail:1753330141@qq.com
# Ver:V1.0
#Date:2018-07-22
#通过WindowsBackup功能备份Windows文件服务器数据，再使用Shell脚本备份至NFS共享

#定义日期
d=`/bin/date +%Y-%m-%d` 
#本地路径
bak_path='/root/bakOCH/bakFSRV_xx.x/'$d
mkdir -p $bak_path
#远程路径
des_folder='WindowsImageBackup'
des_path='//10.xxx.xx.x/e$ -U admin@xxx.cn%xxxxxxxxx'
#切换至本地路径
cd $bak_path
#登录远程路径开始拷贝
smbclient $des_path <<EOF
mask ""
recurse ON
prompt OFF
cd $des_folder
mget *
EOF
