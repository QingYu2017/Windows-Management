'Auth:Qing.Yu
'Mail:1753330141@qq.com
' Ver:V1.0
'Date:UNKNOW

On Error Resume Next

strComputer = "."

'管理员组中删除员工GROUP账号
Set objAdmins = GetObject("WinNT://" & strComputer & "/administrators")

'获取主机信息
Set objNetwork = CreateObject("Wscript.Network")
cmp = objNetwork.ComputerName
usr = objNetwork.UserName

if checkArr(cmp,split(getList,",")) then
	'msgbox "当前PC需要清理"
	clearAdmins(objAdmins)
	else
	'msgbox "当前PC不需要清理"
end if

'清理管理员组
sub clearAdmins(objAdmins)
	For each objUser in objAdmins.Members
		if objUser.name<>"Administrator" and objUser.name<>"Domain Admins" then
			objAdmins.Remove(objUser.ADsPath)
		end if	
	Next
end sub

'返回待维护主机清单
function getList()
	Set conn =CreateObject("ADODB.Connection")
	set rs = CreateObject("ADODB.Recordset")
	conn.ConnectionString = "Driver={sql server};server=10.xxx.xx.21\ccblifeamc;network=dbmssocn;uid=it_support;pwd=1234xxxx;database=IT_Data" 
	conn.ConnectionTimeout = 30 
	conn.Open
	rs.open "select * from client_admin",conn,1,3
	str=""
	while not rs.eof
		str=str+","+rs(1)'+"#"+rs(2)
		rs.movenext
	wend
	set rs=nothing
	Set conn=Nothing
	'清除首位
	getList=right(str,len(str)-1)
end function

'检查是否属于该数组
function checkArr(cmp,arr())
dim str
	checkArr=false
	for each col in arr
		str=col
		if ucase(cmp)=ucase(str) then
			checkArr=true
			exit for
		end if
	next
end function
