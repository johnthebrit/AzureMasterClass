$GitBasePath = 'C:\Users\john\OneDrive\projects\GIT\AzureMasterClass\Part11IaCandDevOps\Bicep'
$RGName = 'RG-007007'

New-AzResourceGroupDeployment -ResourceGroupName $RGName `
    -TemplateFile "$GitBasePath\StorageAccountwithContainer.json"

New-AzResourceGroupDeployment -ResourceGroupName $RGName `
    -TemplateFile "$GitBasePath\StorageAccountwithContainer.json" `
    -StorageAccountType 'Standard_GRS' `
    -WhatIf

#Create Bicep file from ARM JSON template
bicep decompile "$GitBasePath\StorageAccountwithContainer.json"


$RGName = 'RG-BicepDemo'

bicep -v #or --version  check path if necessary sysdm.cpl and user path .bicep remove
bicep build ./storageaccount.bicep #not required anymore

#Need 5.6.0 or above
Get-InstalledModule -Name Az -AllVersions
Find-Module -Name Az #what is available

#For Az need 2.20.0 or above
az version

#Look at the ARM
bicep build "$GitBasePath\storage.bicep"

#Deploy Bicep file
New-AzResourceGroupDeployment -TemplateFile "$GitBasePath\storage.bicep" -ResourceGroupName RG-BicepDemo #will not generate JSON file

#Can still do whatif
New-AzResourceGroupDeployment -TemplateFile "$GitBasePath\storage.bicep" -ResourceGroupName RG-BicepDemo `
    -Type 'Standard_GRS' `
    -WhatIf

#Can use parameter files as well. Uses same JSON format as ARM template, no BICEP specific version

#lets push with the AZ CLI instead
az deployment group what-if -f "$GitBasePath\storage.bicep" -g RG-BicepDemo --parameters type=Standard_GRS

az deployment group create -f "$GitBasePath\storage.bicep" -g RG-BicepDemo --parameters type=Standard_GRS -c