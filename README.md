# helm-github-pages [![CircleCI](https://circleci.com/gh/int128/helm-github-pages.svg?style=shield)](https://circleci.com/gh/int128/helm-github-pages)

Let's publish your Helm Charts on GitHub Pages using CircleCI.

## Getting Started

Create `.circleci/config.yml` with the following content:

```yaml
version: 2
jobs:
  build:
    docker:
      - image: alpine
    steps:
      - checkout
      - run:
          name: helm-github-pages
          command: wget -O - https://raw.githubusercontent.com/int128/helm-github-pages/master/publish.sh | sh
```

Your repository should have the following directories:

- Your Repository
  - `charts/`
    - `awesome_chart/`
      - `Chart.yaml`
      - ...
    - `great_chart/`
      - `Chart.yaml`
      - ...
    - ...

If the master branch is pushed, syntax checking and publishing are performed.
Otherwise, only syntax checking is performed.

You should configure a checkout key in order to publish artifacts into the `gh-pages` branch of the repository.

1. Open settings of your repository on CircleCI.
1. Open the **Checkout SSH keys** in the Permissions section.
1. Click the **Create and add user key** button.

### Environment variables

You can set the following environment variables:

- `HELM_VERSION` = Helm version (defaults to 2.8.1)
- `HELM_CHARTS_SOURCE` = Helm Charts source directory (defaults to `./charts`)

### How it works

This script does the following steps:

1. Check out the `gh-pages` branch.
1. `helm lint` for each chart.
1. `helm package` for each chart.
1. `helm repo index` for all charts.
1. Push the `gh-pages` branch.

## Contribution

This is an open source software licensed under Apache License 2.0.
Feel free to open issues or pull requests.

