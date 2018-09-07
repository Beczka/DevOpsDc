param(
    $tenant_id,
    $client_id,
    $subscription_id,
    $resource_group_name,
    $automation_account_name
)

$client_secret = $Env:ARM_CLIENT_SECRET

Write-Host $automation_account_name
Write-Host $resource_group_name

try {
    $subscription = Get-AzureRmSubscription
}
catch {
    Write-Host "Not logged into azure acount. Logging in.."
    if ($client_id -and ($client_secret -and $tenant_id)) {ls
        $clientSecret = ConvertTo-SecureString $client_secret -AsPlainText -Force
        $cred = New-Object PSCredential($clientId, $clientSecret)
        Login-AzureRmAccount -ServicePrincipal -Credential $cred -TenantId $tenant_id -Subscription $subscription_id
    } else {
        Login-AzureRmAccount -Subscription $subscription_id
    }
}

function Compile-Configs() {
    Write-Host "Starting compiling configs..."
    Get-ChildItem -Path DSCConfigs -Filter "*.ps1" | ForEach-Object {
        Write-Host "Compling \"$_.FullName\""
        Import-AzureRmAutomationDscConfiguration -AutomationAccountName $automation_account_name -ResourceGroupName $resource_group_name -SourcePath $_.FullName -Published -Force

        $job = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $resource_group_name -AutomationAccountName $automation_account_name -ConfigurationName $_.BaseName

        while (($job.EndTime -eq $null) -and ($job.Exception -eq $null)) {
            $job = $job | Get-AzureRmAutomationDscCompilationJob
            Start-Sleep -Seconds 5
        }

        $stream = $job | Get-AzureRmAutomationDscCompilationJobOutput -Stream Any 
        Write-Host $stream.Summary
    }
}

function Upload-Module($name, $url){
    $module  = New-AzureRmAutomationModule -ResourceGroupName $resource_group_name -AutomationAccountName $automation_account_name -Name $name -ContentLink $url

    while (($module.ProvisioningState -ne "Succeeded") -and ($module.ProvisioningState -ne "Failed")) {
        [Threading.Thread]::Sleep(5000)
        Write-Host "'$($name)' Provisioning State :'$($module.ProvisioningState)'"
        $module = Get-AzureRmAutomationModule -Name $name -AutomationAccountName $automation_account_name -ResourceGroupName $resource_group_name
    }
    
    if ($module.ProvisioningState -ne "Succeeded") {
        Write-Error "Failed to upload module '$($name)' (status: '$($module.ProvisioningState)'). Refer to Automation Account logs for details"
    }
}

Upload-Module "cChoco" "https://www.powershellgallery.com/api/v2/package/cChoco/2.3.1.0"
Upload-Module "StorageDsc" "https://www.powershellgallery.com/api/v2/package//StorageDsc/4.1.0.0"
Compile-Configs
