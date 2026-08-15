# frontend-deploy

Continuous-deployment Terraform stack for the frontend tier — re-bakes the golden AMI and rolls the Auto Scaling Group every time a new frontend version is built. Part of the [Expense project](https://github.com/akhildanda/expense-infra-dev).

## Role in the Expense project

Shares its Terraform state (`s3://akhildev/expense-dev-frontend`) with [`expense-infra-dev/09-frontend`](https://github.com/akhildanda/expense-infra-dev/tree/main/09-frontend) — `09-frontend` does the first-time bring-up of the frontend ASG/target group/listener rule, and this repo takes over for every subsequent version rollout.

```
frontend (Jenkinsfile) ──build job──> frontend-deploy (appVersion param)
   └─ terraform apply -var app_version=<X>
         ├─ boot seed EC2 in public subnet
         ├─ remote-exec frontend.sh → ansible-pull (expense-ansible-roles-tf)
         │     → pulls version <X> artifact from Nexus
         ├─ stop instance → bake AMI → terminate seed
         └─ update Launch Template → ASG instance_refresh (rolling, 50% min healthy)
```

This is the one deploy loop in the project that is fully wired end-to-end, from `git push` on `frontend` to a rolled fleet.

## Related repos

- [expense-infra-dev](https://github.com/akhildanda/expense-infra-dev) — provisions the ASG/ALB this repo updates
- [expense-ansible-roles-tf](https://github.com/akhildanda/expense-ansible-roles-tf) — configuration applied to the seed instance
- [frontend](https://github.com/akhildanda/frontend) — publishes the versioned artifact and triggers this job

Full architecture and repo map: [expense-infra-dev](https://github.com/akhildanda/expense-infra-dev#repositories-in-this-project).
