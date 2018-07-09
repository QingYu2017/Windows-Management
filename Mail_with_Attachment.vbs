'#Auth:Qing.Yu
'#Mail:1753330141@qq.com
'# Ver:V1.0
'#Date:2018-07-08

'1 使用批量发送，需启用Office宏功能；
'2 VBA编辑器，按alt+F11进入；
'3 使用时需要安装Office 2016，如果版本不同，切换至VBA编辑器，在工具-》引用中，修改引用的outlook库，替换为当前office版本的outlook库；
'4 客户信息和报告文件名，按示例保存。附件的实际路径，切换至VBA编辑器，修改代码中的e:\mail_test\，替换为实际保存路径；
'5 邮件正文如需要修改，切换至VBA编辑器，参照mail.body示例修改，chr(13)为换行符；
'6 正式发送时，在VBA编辑器中，将mail.to的值，由"1753330141@qq.com"，改为mail_add；
'7 文件编辑完成后，按alt+F8，选择运行；选择运行正式发送前，务必进行测试；

Sub proc()
For i = 2 To 6
    sendMail Cells(i, 2), Cells(i, 3), Cells(i, 4)
Next i
End Sub

Sub sendMail(policy_num, cus_name, mail_add)
Set mail = Outlook.CreateItem(0)
mail.Subject = "邮件标题"
mail.To = mail_add                       '测试地址使用"1753330141@qq.com"
mail.Body = "邮件正文"
mail.Attachments.Add ("E:\mail_test\" & policy_num & ".pdf")
mail.Send
End Sub


