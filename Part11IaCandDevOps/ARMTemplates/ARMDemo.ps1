#Note deploying to an RG. To deploy to a subscription and create RGs and multiple RGs use New-AzDeployment
#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy

$GitBasePath = 'C:\AzureMasterClass\Part11IaCandDevOps\ARMTemplates'

#Deploy simple template creating a storage account
#Can always use whatif to see what would change comparing to reality
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\StorageAccount.json" `
    -TemplateParameterFile "$GitBasePath\StorageAccount.parameters.json" `
    -WhatIf

#Run same template again but override the type of the storage account
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\\StorageAccount.json" `
    -TemplateParameterFile "$GitBasePath\\StorageAccount.parameters.json" `
    -StorageAccountType 'Standard_GRS'

#Could rerun without the parameter and would set it back to LRS!

#Create a virtual network
#No parameter file. Terrible but not the focus here :-)
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\\VirtualNetwork1Subnet.json"

#Run the 2 subnet version
#Forcing complete mode (instead of default incremental). Watch the storage account!
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\\VirtualNetwork2Subnets.json" `
    -Mode Complete

#Deploy a nested template. Note the variables and parameters come from the main template and not from the nested area
#Deploy simple template creating a storage account
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\StorageAccountNested.json"

#Deploy a linked template that is stored in blob (via a SAS since no public anonymous)
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\StorageAccountLinked.json" `
    -StorageAccountType 'Standard_LRS'

#Looking at a secret
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\\keyvaulttest.json" `
    -TemplateParameterFile "$GitBasePath\\keyvaulttest.parameters.json"

#Create a full VM
#In here we have dependson but use only when required
New-AzResourceGroupDeployment -ResourceGroupName RG-00742 `
    -TemplateFile "$GitBasePath\\SimpleWindowsVM.json" `
    -TemplateParameterFile "$GitBasePath\\SimpleWindowsVM.parameters.json"
