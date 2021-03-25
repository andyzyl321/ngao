# Stack Car Subdirectory

This subdirectory contains the configuration required to support and maintain stack_car development and deployment files.

## Docker development setup

1) Install Docker.app 

2) gem install stack_car

3) We recommend committing .env to your repo with good defaults. .env.development, .env.production etc can be used for local overrides and should not be in the repo.

4) sc up

``` bash
gem install stack_car
sc up

```

## Staging Deploys: N8 Architecture

Staging builds and deploys to Notch8 infrastructure are handled by Gitlab CI.

**Setup your `gitlab` git remote**

You'll only need to do this once. You need to set this remote to push, build and deploy your work.
- Run `git remote add gitlab git@gitlab.com:notch8/ngao.git`
- Run `git remote`. You've successfully added the **gitlab** remote if your output lists it. It will look like:
```
> git remote              # Run git remote
gitlab                    # New gitlab remote
origin
```

### To Deploy to N8 Staging

- Branch off the work you intend to deploy prefixing its name with `n8-deploy`
  - Example: If your branch is `staging`, branch off of it naming it something like `n8-deploy-staging`
- Run `git pull gitlab master` into the `n8-deploy-<branchname>` branch you created. This will add the gitlab_ci setup
- Run `git push gitlab n8-deploy-<branchname>`
- Once the build completes, you can deploy via Gitlab **Pipelines** or **Jobs**     

*Note: It may take up to several minutes for the upgrade to complete*

Release and Deployment are handled by the gitlab ci by default.
