Search-AzGraph -Query "summarize count () by subscriptionId" | Format-Table

Search-AzGraph -Query "project name, location, type|
 where type =~ 'Microsoft.Compute/virtualMachines' | order by name desc"

Search-AzGraph -Query "where type =~ 'Microsoft.Compute/virtualMachines' |
 project name, properties.storageProfile.osDisk.osType | top 3 by name desc"

Search-AzGraph -Query "where tags.Role=~'DC' | project name, tags"


Resources
| where type == "microsoft.compute/virtualmachines"
| project  computerNameOverride = tostring(properties.extended.instanceView.computerName), computerName = properties.osProfile.computerName

Resources | 
where type =~ 'Microsoft.Network/publicIPAddresses' |
where properties.ipConfiguration =~ '' |
project name, resourceGroup, subscriptionId, location, tags, id

Resources
	| where type =~ 'Microsoft.Compute/virtualMachines'
	| where properties.osProfile.computerName =~ 'savazuusscwin10' or properties.extended.instanceView.computerName =~ 'savazuusscdc01'
	| join (ResourceContainers | where type=='microsoft.resources/subscriptions' | project SubName=name, subscriptionId) on subscriptionId
    | project VMName = name, CompName = properties.osProfile.computerName, OSType =  properties.storageProfile.osDisk.osType, RGName = resourceGroup, SubName, SubID = subscriptionId
