# Progress log

## 2026-11-24: Design, Terraform code and workflow

- **Done:** Checked the Azure subscription (free account with credit, no resources). Designed a hub-and-spoke network with two spokes per environment. Wrote the `hub-spoke` module (virtual networks, subnets, one network security group per spoke, peering in both directions) and the `dev` and `prod` environments. Wrote a GitHub Actions workflow that signs in with OIDC.
- **Problem:** Trials for Microsoft 365 and Entra ID P2 ask for company details, so they are not usable for an individual. That work was dropped from this portfolio.
- **Fix:** Focus stays on Azure networking and Terraform, which need nothing beyond the subscription.
- **Next:** Create the state storage and the app registration (see `bootstrap.md`), set the repository variables, run the first plan and apply, and capture screenshots of the result.
