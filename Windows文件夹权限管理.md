### 方案设计：
- 通过Powershell脚本获取指定目录权限；
- 通过bat文件执行ps1脚本，结果定向至特定目录的txt文本中；
- 使用Python解析文本，并将关键信息提取至MySQL服务器；
- 通过SSRS链接服务器访问MySQL，创建报告并按时订阅；

### 问题和解决：
- 使用bat并将屏显重定向到txt的过程中，发现单行如果信息较长，会被自动拆分成两段，且txt默认编码gb2312，python读取的时候需要使用decode('gb2312').encode('utf8')方式解码才能正常显示；
- 通过powershell的out-file方式输出，发现python读取乱码（使用上面的decode/encode失败），后发现ps的out-file支持encoding，选择UTF8（区分大小写）后，python解析正常；
- 返回数据提交给MySQLdb，发现\全部被删除，确认后发现，MySQLdb对\做了保留处理，需要将\替换成\\，在python中实现，需要str.replace('\\','\\\\');
- powershell可以通过Get-Help Out-File -Detailed等方式，查阅命令的详细信息；

##### SQL中创建视图：
```sql
create view v_folder_acl as
select * from openquery(Zabbix,'select * from IT_Mgr.ACLinfo where left(check_date,10)=left(now(),10);')
```
##### SSRS查询
```sql
select case when folder_path like '%public%' then '部门共享' else '部门专用' end folder_type,
right(folder_path,len(folder_path)-charindex('$',folder_path)-1) folder_path,auth_usr,auth_type,auth_right
from v_folder_acl where auth_usr not like ('%Administrator')
```
##### getACL.ps1脚本
```powershell
Get-Acl 'D:\PublicFolder$\*' |fl |out-file -Encoding UTF8 -filepath "D:\PublicFolder$\D11_信息技术部共享\01 文件夹权限管理\ACLinfo.txt"
Get-Acl 'D:\ShareFolder$\*' |fl |out-file -append -Encoding UTF8 -filepath "D:\PublicFolder$\D11_信息技术部共享\01 文件夹权限管理\ACLinfo.txt"
```
-Encoding <string>
- 指定在文件中使用的字符编码的类型。有效值是"Unicode"、"UTF7"、"UTF8"、"UTF32"、"ASCII"、"BigEndianUnicode"、"Default"和"OEM"。默认值为"Unicode"。
##### 运行批处理getACL.bat
```bat
powershell "C:\Users\administrator.AMCDOMAIN\Documents\PS_Script\getACL.ps1" >"D:\PublicFolder$\D11_信息技术部共享\01 文件夹权限管理\ACLinfo.txt"
```
- 如果目录名称包含空格，必须用""包含，否则会执行错误
- 如果提示无权限，需要先允许脚本执行，PS环境下运行 Set-ExecutionPolicy RemoteSigned
- Linux上创建Remote_Folder/ACLinfo，映射共享权限信息，再用Python解析该文件，导入MySQL后，通过SSRS生成定期报告；
```shell
mount -o username=administrator,password=#passwd# "//10.201.11.9/publicfolder$/D11_信息技术部共享/01 文件夹权限管理" /root/Remote_Folder/ACLinfo
```
###### MySQLdb中创建数据库
```sql
create Database IT_Mgr;
create table ACLinfo(check_date datetime,folder_path nvarchar(100),auth_usr nvarchar(100),auth_type nvarchar(100),auth_right nvarchar(100));
```



