#Auth:Qing.Yu
#Mail:1753330141@qq.com
# Ver:V1.0
#Date:2018-07-17
#按照组策略名备份至指定目录

Import-Module GroupPolicy
$date = Get-Date -Format yyyy-MM-dd
$Path = "C:\OCH_GPOBAK\$date"
Get-GPO -All | % {
    $name = $_.DisplayName
    $dir = New-Item "$Path\$name" -Type Directory
    Backup-GPO -Guid $_.Id -Path $dir
  }
