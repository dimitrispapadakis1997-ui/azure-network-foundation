# Azure Network Foundation with Terraform

A hub-and-spoke network in Azure, defined as code. Separate `dev` and `prod` environments share one reusable module and are deployed by a GitHub Actions pipeline that signs in with OIDC (no stored secrets).

**Status:** 🚧 In progress. See [docs/progress-log.md](docs/progress-log.md).

## Architecture

```
                 +----------------------+
                 |   hub vnet (/16)     |
                 |   snet-shared        |
                 +----------+-----------+
                  peering   |   peering
              +-------------+-------------+
              |                           |
   +----------+-----------+   +-----------+----------+
   |  spoke vnet: app     |   |  spoke vnet: data    |
   |  snet-workload + NSG |   |  snet-workload + NSG |
   +----------------------+   +----------------------+
```

| Environment | Hub | Spoke `app` | Spoke `data` |
|---|---|---|---|
| dev | 10.10.0.0/16 | 10.11.0.0/16 | 10.12.0.0/16 |
| prod | 10.20.0.0/16 | 10.21.0.0/16 | 10.22.0.0/16 |

Region: `norwayeast`.

## Design decisions

- **One module, two environments.** `modules/hub-spoke` holds all the logic. `envs/dev` and `envs/prod` only supply values, so the environments cannot drift apart in structure.
- **Spokes with `for_each`.** Adding a spoke is one line in the environment, not new resource blocks.
- **Subnets derived with `cidrsubnet`.** Each subnet is calculated from its virtual network, so address plans stay consistent.
- **Peering in both directions.** Azure needs a peering on each side before traffic flows.
- **NSG per spoke.** Allow traffic from inside the virtual network (priority 100), deny all other inbound traffic (priority 4096).
- **Remote state in Azure Storage**, one state file per environment, accessed with Azure AD authentication instead of keys.
- **OIDC instead of a client secret.** The pipeline receives a short-lived token per run. See [docs/bootstrap.md](docs/bootstrap.md).
- **No hourly-billed services.** No VPN Gateway, Azure Firewall or Bastion, to keep the cost close to zero.

## Pipeline

On every pull request the workflow runs format check, init, validate and plan for both environments. On a push to `main` it also applies.

## Layout

```
modules/hub-spoke/   reusable network module
envs/dev/            dev environment
envs/prod/           prod environment
.github/workflows/   CI/CD pipeline
docs/                bootstrap steps and progress log
```

## Skills shown

Azure networking, Terraform (modules, `for_each`, remote state), GitHub Actions, OIDC federation, least-privilege role assignments, cost awareness.
