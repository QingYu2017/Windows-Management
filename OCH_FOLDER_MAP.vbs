	On Error Resume Next
	
	Set objNetwork = CreateObject("Wscript.Network")
	Set oShell = CreateObject("Shell.Application") 
	objNetwork.RemoveNetworkDrive "P:"
		
	strHQ="\\10.xxx.xx.8\ShareFolder"
		
	objNetwork.MapNetworkDrive "P:", strHQ, true
	oShell.NameSpace("P:\").Self.Name = "华侨集团共享"
	
	objNetwork.RemoveNetworkDrive "S:"
		
	strHQ="\\10.xxx.xx.8\BizFolder"
		
	objNetwork.MapNetworkDrive "S:", strHQ, true
	oShell.NameSpace("S:\").Self.Name = "部门专用"
