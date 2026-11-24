# Progress log

## 2026-11-24: Environments destroyed, then re-applied by accident

- **Done:** Destroyed the dev and prod environments to avoid cost, after checking them in the portal.
- **Problem:** A later commit to `main` in this repository (removing an unrelated environment) matched the workflow's path filter (`envs/**`), so the pipeline ran its apply job and created the dev and prod networks again. I found them when the audit in `azure-governance-audit` listed network security groups that should not exist.
- **Fix:** Deleted the two resource groups again in the portal. The state is now empty again.
- **Lesson:** A pipeline that applies on every push to `main` recreates destroyed infrastructure as soon as any commit touches a watched path. The follow-up project `azure-cicd-monitoring` solves this properly: apply only runs from a saved plan, behind a manual approval in the `production` environment.

## 2026-11-24: First successful pipeline run

- **Done:** Created the state storage, the app registration with federated credentials, the role assignments and the repository variables (see `bootstrap.md`). The `terraform` workflow ran plan and apply for `dev` and `prod` against Azure with OIDC and remote state.
- **Problem:** Sign-in failed with `AADSTS700213`. GitHub sent a subject with immutable owner and repository IDs, while the federated credentials used the classic `repo:owner/name` format. Right after the fix one job failed once more, because Entra ID had not applied the change yet.
- **Fix:** Recreated both credentials with the owner ID and repository ID, then re-ran the failed job. Both environments applied.
- **Next:** Check the resources in the portal, add screenshots, then destroy everything to avoid cost.

## 2026-11-24: Design, Terraform code and workflow

- **Done:** Checked the Azure subscription (free account with credit, no resources). Designed a hub-and-spoke network with two spokes per environment. Wrote the `hub-spoke` module (virtual networks, subnets, one network security group per spoke, peering in both directions) and the `dev` and `prod` environments. Wrote a GitHub Actions workflow that signs in with OIDC.
- **Problem:** Trials for Microsoft 365 and Entra ID P2 ask for company details, so they are not usable for an individual. That work was dropped from this portfolio.
- **Fix:** Focus stays on Azure networking and Terraform, which need nothing beyond the subscription.
