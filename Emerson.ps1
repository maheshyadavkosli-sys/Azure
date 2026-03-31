$Computername = Read-Host "Enter ComputerName" 
$Credential = Get-Credential
Invoke-Command -Computername "$Computername" -Credential "$Credential" -ScriptBlock {
Set-NetAdapterAdvancedProperty -Name "Wi-Fi" -DisplayName "Roaming Aggressiveness" -DisplayValue "1. Lowest"

Set-NetAdapterAdvancedProperty -Name "Wi-Fi" -DisplayName "Preferred Band" -DisplayValue "2. Prefer 2.4GHz band"

Get-NetAdapterAdvancedProperty -Name "Wi-Fi" -DisplayName "Roaming Aggressiveness","Preferred Band"}

Read-Host -Prompt "Press Enter to exit"
