#region Install IIS 
Install-WindowsFeature -name Web-Server -IncludeManagementTools
#endregion

#region  Ping
New-NetFirewallRule -DisplayName "Allow Ping Public" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow -Profile Public -Enabled True
#endregion
#region Set Timezone to Central 
Set-TimeZone -Name "Central Standard Time"
#endregion
#region Print Hostname & IP Address to IIS htm file
$outputFile = "C:\inetpub\wwwroot\iisstart.htm" # Specify your desired file path

"Hostname: $env:COMPUTERNAME" | Out-File -FilePath $outputFile
"IP Addresses:" | Out-File -Append -FilePath $outputFile

Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" -and $_.AddressState -eq "Preferred" } | Select-Object -ExpandProperty IPAddress | Out-File -Append -FilePath $outputFile

"--- Done ---" | Out-File -Append -FilePath $outputFile

#endregion

#region Storage-General-Purpose-Account-V2

Get-AzStorageAccount
Get-AzVirtualNetwork
New-AzResourceGroupDeployment -TemplateUri "C:\Users\mahesh\Desktop\STA-Template\STA-template.json" -TemplateParameterFile "C:\Users\mahesh\Desktop\STA-Template\STA-parameters.json"
#endregion
#region Virtual-Machine-Deployment Template

Get-AzVirtualNetwork
Get-AzVM

#endregion


#Changing all route tables at once 
# Define variables
$location = read-host -prompt "location"
$resourceGroup = read-host -prompt "Resource Group"
$routeTableName = read-host -prompt "Route Table"
$newNextHopIp = read-host -prompt "New Next Hop" # New IP address
$newNextHopType = "VirtualAppliance"
$sourceRouteTable = Get-AzRouteTable -ResourceGroupName $resourceGroup -Name "USA-Route-Table"
New-AzRouteTable -ResourceGroupName $resourceGroup -Name $routeTableName -Location $location -Route $sourceRouteTable.Routes
# 1. Get the current Route Table object
$routeTable = Get-AzRouteTable -ResourceGroupName $resourceGroup -Name $routeTableName

# 2. Iterate through each route and update its config in the local object
foreach ($route in $($routeTable.Routes)) {
    $routeTable = Set-AzRouteConfig -RouteTable $routeTable `
                                   -Name $route.Name `
                                   -AddressPrefix $route.AddressPrefix `
                                   -NextHopType $newNextHopType `
                                   -NextHopIpAddress $newNextHopIp
}

# 3. Save the modified Route Table back to Azure
$routeTable | Set-AzRouteTable


# Get all VMs in a specific Resource Group
$vms = Get-AzVM -ResourceGroupName "HR"

# Loop through and run the command
$vms | ForEach-Object -Parallel {
    Invoke-AzVMRunCommand -ResourceGroupName $_.ResourceGroupName `
                          -VMName $_.Name `
                          -CommandId 'RunPowerShellScript' `
                          -ScriptPath 'C:\Data\VM.ps1'
} -ThrottleLimit 10




stop-service -name RemoteAccess

Set-Service -Name "RemoteAccess" -Status Running -StartupType Automatic
Start-service -Name RemoteAccess
