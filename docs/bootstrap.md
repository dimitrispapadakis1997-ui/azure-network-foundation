# Bootstrap

Terraform cannot create the things it needs in order to run: the storage for its own state and the identity the pipeline signs in with. These are created once by hand in the Azure portal. Everything else is code.

## Resources created by hand

| Resource | Name | Notes |
|---|---|---|
| Resource group | `rg-tfstate` | Region `norwayeast` |
| Storage account | `sttfstate<random>` | LRS, blob public access disabled |
| Blob container | `tfstate` | Holds `dev.tfstate` and `prod.tfstate` |
| App registration | `github-terraform-azure-network-foundation` | No client secret is created |
| Federated credential 1 | `repo:dimitrispapadakis1997-ui/azure-network-foundation:pull_request` | Used by plan on pull requests |
| Federated credential 2 | `repo:dimitrispapadakis1997-ui/azure-network-foundation:ref:refs/heads/main` | Used by plan and apply on main |
| Role assignment | Contributor | Scope: the subscription |
| Role assignment | Storage Blob Data Contributor | Scope: the state storage account |

## Why OIDC and no secret

The pipeline gets a short-lived token from GitHub for each run and exchanges it for an Azure token. There is no password or key stored in GitHub, so nothing can leak or expire unnoticed.

## Repository variables

These are variables, not secrets, because none of them is sensitive on its own.

| Variable | Value |
|---|---|
| `AZURE_CLIENT_ID` | Application (client) ID of the app registration |
| `AZURE_TENANT_ID` | Directory (tenant) ID |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID |
| `TFSTATE_RESOURCE_GROUP` | `rg-tfstate` |
| `TFSTATE_STORAGE_ACCOUNT` | The storage account name |

## Cost

The subscription is a free account with a limited credit. Virtual networks, peering and network security groups cost very little. Hourly-billed services (VPN Gateway, Azure Firewall, Bastion) are deliberately not used. Everything is destroyed when the project is documented.
