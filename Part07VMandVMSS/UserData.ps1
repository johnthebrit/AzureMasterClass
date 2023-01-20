$accessToken = (Get-AzAccessToken).Token #ARM audience
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'='Bearer ' + $accessToken
}

$vm = Get-AzVM -Name DemoVM -ResourceGroupName RG-DemoVM

#Base 64 endcoding
$userDataText = "HelloTest1"
$userDataBase64 = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($userDataText))
#Test decode
[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($userDataBase64))

#use a here-string for the json body
$Body = @"
{
    "properties": {
        "userData": "$userDataBase64"
    }
}
"@

#Submit the REST call
$resp = Invoke-WebRequest -Uri "https://management.azure.com/$($vm.Id)?api-version=2022-11-01" -Method PATCH -Body $Body -Headers $authHeader

#Get
$resp = Invoke-WebRequest -Uri "https://management.azure.com/$($vm.Id)?api-version=2022-11-01" -Method Get -Headers $authHeader
$resp.content

#To deploy via ARM see https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-userdata



#On the VM to read
#Raw data
$respraw=Invoke-WebRequest -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance?api-version=2021-12-13"
$respraw
$respraw.Content
$respraw.Content | ConvertFrom-Json | ConvertTo-Json -Depth 6

#A better way that automatically creates us a nice PowerShell object with the response
$resp=Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance?api-version=2021-12-13"
$respJSON = $resp | ConvertTo-Json -Depth 6

#Compute only, could do Network, all the main JSON headings
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance/compute?api-version=2021-12-13"

#Just get tags
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance/compute/tagsList?api-version=2021-12-13"

#Lets look at some of it
Write-Output "VM name - $($resp.compute.name), RG - $($resp.compute.resourceGroupName), VM size - $($resp.compute.vmSize)"

#userData view
$resp.compute.userData
[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($resp.compute.userData))

#Scheduled events (this includes things like terminations if VMSS with grace window)
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/scheduledevents?api-version=2020-07-01"

<#
EventId : ID
EventStatus : Scheduled
EventType : Terminate
ResourceType : VirtualMachine
Resources : {vmss_3}
NotBefore : Tue, 04 May 2022 03:25:23 GMT
#>

#Linux
curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-12-13" | jq