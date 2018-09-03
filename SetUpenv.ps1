# For VSTS
# iex (wget 'https://chocolatey.org/install.ps1' -UseBasicParsing);
# choco install terraform

# terraform import module.dev-env.module.app-insights.azurerm_application_insights.app-insights /subscriptions/8e6e7e57-3e8f-42c3-8613-44e2bff63657/resourceGroups/dev-westeurope/providers/microsoft.insights/components/dev-mirror-app-insights

[Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", "", "Process")