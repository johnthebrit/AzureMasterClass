Search-AzGraph -Query "summarize count () by subscriptionId" | Format-Table

#to see the x-ms-user-quota-remaining and -resets-after value
Search-AzGraph -Query "summarize count () by subscriptionId" -debug

Search-AzGraph -Query "project name, location, type|
 where type =~ 'Microsoft.Compute/virtualMachines' | order by name desc"

Search-AzGraph -Query "where type =~ 'Microsoft.Compute/virtualMachines' |
 project name, properties.storageProfile.osDisk.osType | top 3 by name desc"

Search-AzGraph -Query "where tags.Role=~'DC' | project name, tags"


Resources
| where type == "microsoft.compute/virtualmachines"
| project  computerNameOverride = tostring(properties.extended.instanceView.computerName), computerName = properties.osProfile.computerName

#Unused public IPs
Resources | 
where type =~ 'Microsoft.Network/publicIPAddresses' |
where properties.ipConfiguration =~ '' |
project name, resourceGroup, subscriptionId, location, tags, id

#Find VM by guest OS name.
Resources
	| where type =~ 'Microsoft.Compute/virtualMachines'
	| where properties.osProfile.computerName =~ 'demoVM' or properties.extended.instanceView.computerName =~ 'demoVM'
	| join (ResourceContainers | where type=='microsoft.resources/subscriptions' | project SubName=name, subscriptionId) on subscriptionId
    | project VMName = name, CompName = properties.osProfile.computerName, OSType =  properties.storageProfile.osDisk.osType, RGName = resourceGroup, SubName, SubID = subscriptionId

#Last 7 days of Create changes
ResourceChanges
	| extend targetResourceId = tostring(properties.targetResourceId), changeType = tostring(properties.changeType), changeTime = todatetime(properties.changeAttributes.timestamp)
	| where changeTime > ago(7d) and changeType == "Create"
	| project  targetResourceId, changeType, changeTime
	| join ( Resources | extend targetResourceId=id) on targetResourceId
	| order by changeTime desc
	| project changeTime, changeType, id, resourceGroup, type, properties

#Subscriptions with Azure Firewall and AKS
Resources
| where type =~ 'microsoft.network/azurefirewalls'
| project fwname = name, subscriptionId
| join kind=inner (
    Resources
    | where type =~ 'microsoft.containerservice/managedclusters'
    | project aksname = name, subscriptionId)
on subscriptionId
| distinct subscriptionId, fwname
| join kind=leftouter (ResourceContainers | where type=='microsoft.resources/subscriptions' | project SubName=name, subscriptionId) on subscriptionId
| project-away subscriptionId1