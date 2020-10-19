#Query metadata service for general information
$uri = "http://169.254.169.254/metadata/instance?api-version=2020-06-01"
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri $uri | ConvertTo-Json

#Get tags
$uri = "http://169.254.169.254/metadata/instance/compute/tagsList?api-version=2020-06-01"
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri $uri | ConvertTo-Json

#Network info
$uri = "http://169.254.169.254/metadata/instance/network?api-version=2020-06-01"
(Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri $uri).interface.ipv4

#What cloud running in
$uri = "http://169.254.169.254/metadata/instance/compute/azEnvironment?api-version=2020-06-01&format=text"
Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri $uri

#Any scheduled events
$uri = "http://169.254.169.254/metadata/scheduledevents?api-version=2019-01-01"
$response = ((Invoke-WebRequest -Uri $uri -Method Get -Headers @{Metadata="true"}).Content | ConvertFrom-Json).Events
$response

<#
EventId : 7D834D47-783D-4F9F-8CDA-87FE3EB6D3B1
EventStatus : Scheduled
EventType : Terminate
ResourceType : VirtualMachine
Resources : {vmss_5}
NotBefore : Fri, 09 Oct 2020 13:25:49 GMT
#>

#Check managed disk fault domains
#https://docs.microsoft.com/en-us/azure/virtual-machines/manage-availability
Get-AzComputeResourceSku | where{$_.ResourceType -eq 'availabilitySets' -and $_.Name -eq 'Aligned'}