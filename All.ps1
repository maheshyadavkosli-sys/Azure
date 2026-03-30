# Install IIS 
Install-WindowsFeature -name Web-Server -IncludeManagementTools
#######################################################################################################################################################################################################################################
#Allow Ping
New-NetFirewallRule -DisplayName "Allow Ping Public" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow -Profile Public -Enabled True
#######################################################################################################################################################################################################################################
# Set Timezone to Central 
Set-TimeZone -Name "Central Standard Time"
#######################################################################################################################################################################################################################################
# Print Hostname & IP Address to IIS htm file
$outputFile = "C:\inetpub\wwwroot\iisstart.htm" # Specify your desired file path

"Hostname: $env:COMPUTERNAME" | Out-File -FilePath $outputFile
"IP Addresses:" | Out-File -Append -FilePath $outputFile

Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" -and $_.AddressState -eq "Preferred" } | Select-Object -ExpandProperty IPAddress | Out-File -Append -FilePath $outputFile

"--- Done ---" | Out-File -Append -FilePath $outputFile
Read-Host -Prompt "Press Enter to continue..."
#######################################################################################################################################################################################################################################
#Storage-General-Purpose-Account-V2
Get-AzStorageAccount
Get-AzVirtualNetwork
New-AzResourceGroupDeployment -TemplateUri "C:\Users\mahesh\Desktop\STA-Template\STA-template.json" -TemplateParameterFile "C:\Users\mahesh\Desktop\STA-Template\STA-parameters.json"
################################################################################################################################################################################################################################################
#Virtual-Machine-Deployment Template
Get-AzVirtualNetwork
Get-AzVM


