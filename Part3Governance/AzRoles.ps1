Get-AzRoleDefinition | FT Name, Description
Get-AzRoleDefinition | measure
Get-AzRoleDefinition Contributor | FL Actions, NotActions
(Get-AzRoleDefinition "Virtual Machine Contributor").Actions

#look at roles that have something to do with compute
$roles = Get-AzRoleDefinition
foreach ($roledef in $roles) {
 if ($roledef.Actions -match "^Microsoft.Compute/virtualMachines/" -or
$roledef.Actions -match "^Microsoft.Compute/\*" -or $roledef.Actions -match
"^\*/")
 {
 Write-Output "Role: $($roledef.Name)"
 }
}

#create a new role based on existing
Get-AzProviderOperation "Microsoft.Compute/virtualMachines/*" | FT OperationName, Operation, Description -AutoSize
$sub = Get-AzSubscription -SubscriptionName "SavillTech Dev Subscription"
$role = Get-AzRoleDefinition "Virtual Machine Contributor"
$role.Name = "Virtual Machine Operator"
$role.Description = "Can monitor and restart virtual machines."
$role.Actions.Remove("Microsoft.Compute/virtualMachines/*")
$role.Actions.Remove("Microsoft.Compute/virtualMachineScaleSets/*")
$role.Actions.Add("Microsoft.Compute/virtualMachines/read")
$role.Actions.Add("Microsoft.Compute/virtualMachines/start/action")
$role.Actions.Add("Microsoft.Compute/virtualMachines/restart/action")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/$($sub.id)")
New-AzRoleDefinition -Role $role