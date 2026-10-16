$resourceGroupName = "biceptest$(get-date -Format yyyyMMddHHmm)-Dev"
$region = 'eastus'

New-AzResourceGroup -Name $resourceGroupName -Location $region 

try {
    $result = New-AzResourceGroupDeployment -Name "localtest" -ResourceGroupName $resourceGroupName -TemplateFile $PSScriptRoot/main.test.bicep
}
catch {
    Write-Output $_
}
finally {
    
}

Write-Output $result
Remove-AzResourceGroup -Name $resourceGroupName -Force