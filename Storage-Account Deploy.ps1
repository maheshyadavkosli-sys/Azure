#Storage-General-Purpose-Account-V2
New-AzResourceGroupDeployment -TemplateFile ".\STA-template.json" -TemplateParameterFile ".\STA-parameters.json"

#Virtual-Machine-Deployment Template

New-AzResourceGroupDeployment -TemplateFile .\VM-template.json -TemplateParameterFile .\VM-parameters.json