# helm-github-pages [![CircleCI](https://circleci.com/gh/int128/helm-github-pages.svg?style=shield)](https://circleci.com/gh/int128/helm-github-pages)

Let's publish your Helm Charts on GitHub Pages using CircleCI.

## Getting Started

It takes just 3 steps.

### 1. Create a GitHub repository

Create a repository with the following structure:

- Your Repository
  - `.circleci/`
    - `config.yml`
  - `charts/`
    - `awesome_chart/`
      - `Chart.yaml`
      - ...
    - `great_chart/`
      - `Chart.yaml`
      - ...
    - ...

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
    branches:
      ignore:
        - gh-pages
```

Alternatively, you can store [publish.sh](publish.sh) into `.circleci` directory and call it as follows:

```yaml
      - run:
          name: helm-github-pages
          command: .circleci/publish.sh
```

### 2. Setup CircleCI

Open CircleCI and start building.

You should configure a checkout key in order to write charts into the `gh-pages` branch of the repository.

1. Open settings of your repository on CircleCI.
1. Open the **Checkout SSH keys** in the Permissions section.
1. Click the **Create and add user key** button.

If the master branch is pushed, syntax checking and publishing are performed.
Otherwise, only syntax checking is performed.

### 3. Verify the Helm repository

You can add the Helm repository as follows:

```sh
helm repo add helm-github-pages https://int128.github.io/helm-github-pages
helm repo update
helm repo list
```

Verify that your chart is available.

```sh
helm inspect helm-github-pages/examples
```

## Furthermore

### Configurations

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

It assumes running on the Alpine image and CircleCI docker environment.

## Contribution

This is an open source software licensed under Apache License 2.0.
Feel free to open issues or pull requests.

