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

## Staging Deploys

Staging builds and deploys to Notch8 infrastructure are currently manual (gitlab ci support soon to come).

You will need to:
- Build the image
- Push the image to the Gitlab registry
- Deploy via `chart/bin` scripts

### To Deploy to Staging

**Build the image**
- `TAG=staging sc build`

**Push the image to Gitlab**
- `docker push registry.gitlab.com/notch8/ngao:staging`

**Deploy**
- `chart/bin/deploy staging staging`

*Note: It may take up to several minutes for the upgrade to complete*

# Deploy a new release

``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Releaese and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image
