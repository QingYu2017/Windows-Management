#! /usr/bin/python
# -*- coding: utf-8 -*- 
#Auth:Qing.Yu
#Mail:1753330141@qq.com
# Ver:V1.0
#Date:2016-09-13

#create Database IT_Mgr;
#create table ACLinfo(check_date datetime,folder_path nvarchar(100),auth_usr nvarchar(100),auth_type nvarchar(100),auth_right nvarchar(100));

import os,re,MySQLdb

#插入数据库
def db_insert(folder_path,auth_usr,auth_type,auth_right):
	conn=MySQLdb.connect(host='localhost',user='root',passwd='xxpwdxx',db='IT_Mgr',port=3306,charset="utf8")
	cur=conn.cursor()
	sql_str="insert into IT_Mgr.ACLinfo(check_date,folder_path,auth_usr,auth_type,auth_right)values(now(),'%s','%s','%s','%s');"%(folder_path,auth_usr,auth_type,auth_right)
	cur.execute(sql_str.replace("\\","\\\\"))
	cur.close()
	conn.close()

file=open('/root/Remote_Folder/ACLinfo/ACLinfo.txt')

txt=file.read()

#txt=txt.decode('gb2312').encode('utf8')
#print txt

re_block='Path[\s\S]*?Sddl'

blocks=re.findall(re_block,txt)

#print len(blocks)

re_path='Path.*'
re_access='Access[\s\S]*?Audit'
re_right='AMCDOMAIN.*'

for block in blocks:
	#print re.findall(re_path,block)[0]
	#print re.findall("::.*",re.findall(re_path,block)[0])[0]
	path=re.findall(re_path,block)[0]
	path=re.findall("::.*",path)[0][2:]
	print path
	access=re.findall(re_access,block)[0]
	#print access
	rights=re.findall(re_right,access)
	#print path[2:].replace("\r","")
	#print "路径 %s "% path
	for right in rights:
		col=right.split(" ")
		#print col
		_right=""
		for i in range(2,len(col)-1):
			_right+=col[i]
		#print "路径 %s 账号 %s 访问类型 %s 权限 %s "%(path,col[0],col[1],_right)	
		db_insert(path,col[0],col[1],_right)

