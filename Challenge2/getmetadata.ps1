#Author:Lakshmikanth
#this looks metadata for a Azure Instance
$ipofVm='xxx.xxx.xxx.xxx'
$propertytolookfor='osType'
$jsonobj=Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri "http://$ipofVm/metadata/instance?api-version=2021-02-01" | ConvertTo-Json -Depth 64
Write-host "$propertytolookfor for the instance is $($jsonobj.$($propertytolookfor))"