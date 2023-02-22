Get-AzResourceGroup -Name mgmt-centralus -Debug
<#
x-ms-ratelimit-remaining-subscription-reads: 11999
#>

Search-AzGraph -Query 'Resources | where type =~ "microsoft.compute/virtualmachines" | limit 5' -Debug
<#
x-ms-user-quota-remaining     : 14
x-ms-user-quota-resets-after  : 00:00:05
#>

<#
* VM by power state

Resources
    | where type == 'microsoft.compute/virtualmachines'
    | summarize count() by tostring(properties.extended.instanceView.powerState.code)


* Unused Managed Disks

Resources | 
    where type =~ 'Microsoft.Compute/disks' | 
    where managedBy =~ '' | 
    project name, resourceGroup, subscriptionId, location, tags, sku.name, id


* Unused Public IPs

Resources | 
    where type =~ 'Microsoft.Network/publicIPAddresses' |
    where properties.ipConfiguration =~ '' |
    project name, resourceGroup, subscriptionId, location, tags, id

* Cosmos DB withour private endpoint

resources
| where type == "microsoft.documentdb/databaseaccounts"
| where isnull(properties['privateEndpointConnections'])
| project dbname = name, rgname = resourceGroup, subscriptionId
| join kind=leftouter (
    resourcecontainers
    | where type=='microsoft.resources/subscriptions'
    | project SubName=name, subscriptionId)
on subscriptionId
| project-away subscriptionId1
#>