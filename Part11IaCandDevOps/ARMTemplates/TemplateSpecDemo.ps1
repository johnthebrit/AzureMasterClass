$GitBasePath = 'C:\Users\john\OneDrive\projects\GIT\AzureMasterClass\Part11IaCandDevOps\ARMTemplates'
$RGName = 'YOURRGNAMEHERE'

#Create a new template spec
New-AzTemplateSpec -Name Basic-Storage-Account -Version 1.0 -ResourceGroupName RG-TemplateSpecs -Location southcentralus `
    -TemplateFile "$GitBasePath\StorageAccount.json"

Get-AzTemplateSpec

Get-AzTemplateSpec -ResourceGroupName RG-TemplateSpecs -Name Basic-Storage-Account

#Get the template spec ID for a version then deploy
$id = (Get-AzTemplateSpec -ResourceGroupName RG-TemplateSpecs -Name Basic-Storage-Account -Version 1.0).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateSpecId $id

#with parameter file
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateSpecId $id `
    -TemplateParameterFile "$GitBasePath\StorageAccount.parameters.json" `
    -WhatIf

#Adding a new version
New-AzTemplateSpec -Name Basic-Storage-Account -Version 1.1 -ResourceGroupName RG-TemplateSpecs -Location southcentralus `
    -TemplateFile "$GitBasePath\StorageAccount.json"


#Deploying a linked template today (need public accessible path)
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile "$GitBasePath\StorageAccountLinkedGitHub.json" `
    -TemplateParameterFile "$GitBasePath\StorageAccount.parameters.json" `
    -WhatIf

#Create template spec from file with local link
New-AzTemplateSpec -Name Linked-Storage-Account -Version 1.0 -ResourceGroupName RG-TemplateSpecs -Location southcentralus `
    -TemplateFile "$GitBasePath\StorageAccountLinkedLocal.json"

$id = (Get-AzTemplateSpec -ResourceGroupName RG-TemplateSpecs -Name Linked-Storage-Account -Version 1.0).Versions.Id
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateSpecId $id -WhatIf


#Deploy linking to a template spec from local template (i.e. using template spec as a module within a template)
New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile "$GitBasePath\StorageAccountLinkedTempSpec.json" -WhatIf

New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile "$GitBasePath\StorageAccountLinkedTempSpec.json" `
    -TemplateParameterFile "$GitBasePath\StorageAccount.parameters.json" `
    -WhatIf

#Template spec creation that uses another template spec
New-AzTemplateSpec -Name SpecLinked-Storage-Account -Version 1.0 -ResourceGroupName RG-TemplateSpecs -Location southcentralus `
    -TemplateFile "$GitBasePath\StorageAccountLinkedTempSpec.json"