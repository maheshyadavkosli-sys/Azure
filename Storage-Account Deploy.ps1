#Storage-General-Purpose-Account-V2

Get-AzVM | format-table Name, ResourceGroupName, Location 
$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location"

New-AzResourceGroupDeployment -Location $location -ResourceGroupName $resourceGroupName -TemplateUri "C:\Users\mahesh\Desktop\STA-Template\STA-template.json" -TemplateParameterFile "C:\Users\mahesh\Desktop\STA-Template\STA-parameters.json"

Read-Host -Prompt "Press Enter to continue..."

#############################################################################

#Virtual-Machine-Deployment Template


New-AzResourceGroupDeployment -TemplateFile .\VM-template.json -TemplateParameterFile .\VM-parameters.json

$adminPassword = Read-Host -Prompt "Enter the administrator password" -AsSecureString
New-AzResourceGroupDeployment -TemplateFile .\VM-template.json -TemplateParameterFile .\VM-parameters.json  -adminpassword $adminPassword




$resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
$location = Read-Host -Prompt "Enter the location (i.e. centralus)"
$adminUsername = Read-Host -Prompt "Enter the administrator username"
$adminPassword = Read-Host -Prompt "Enter the administrator password" -AsSecureString
$dnsLabelPrefix = Read-Host -Prompt "Enter an unique DNS name for the public IP"

New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile .\VM-template.json -TemplateParameterFile .\VM-parameters.json -adminUsername $adminUsername -adminPassword $adminPassword -dnsLabelPrefix $dnsLabelPrefix

(Get-AzVm -ResourceGroupName $resourceGroupName).name