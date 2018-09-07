param(
    $subscription_id,
    $client_id,
    $tenant_id,
    $vault_name,
    $resource_group,
    $automation_account_name
)

$client_secret = $Env:ARM_CLIENT_SECRET

$userPassword = ConvertTo-SecureString -String $client_secret -AsPlainText -Force
$userCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $client_id, $userPassword

Write-Host "subscription_id => $subscription_id"
Write-Host "client_id => $client_id"
Write-Host "client_secret => $client_secret"
Write-Host "tenant_id => $tenant_id"

Write-Host "vault_name => $vault_name"

Write-Host "resource_group => $resource_group"
Write-Host "automation_account_name => $automation_account_name"

Write-Host "userPassword => $userPassword"

function Save-To-Kv($name_of_secret, $value_of_secret) 
{
    Write-Host "Saving $name_of_secret to kv"
    
    $secret = ConvertTo-SecureString -String $value_of_secret -AsPlainText -Force
    Set-AzureKeyVaultSecret -VaultName $vault_name -Name $name_of_secret  -SecretValue $secret
}

Connect-AzureRmAccount -TenantId $tenant_id -ServicePrincipal -SubscriptionId $subscription_id -Credential $userCredential 
$account = Get-AzureRmAutomationRegistrationInfo -ResourceGroup $resource_group -AutomationAccountName $automation_account_name

Write-Host "Start saving automation account keys to kv"

Save-To-Kv "automation-account-primary-key" $account.PrimaryKey
Save-To-Kv "automation-account-secondary-key" $account.SecondaryKey
Save-To-Kv "automation-account-endpoint" $account.Endpoint

Write-Host "End saving automation account keys to kv"

