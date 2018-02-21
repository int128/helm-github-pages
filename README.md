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

### Configuration

You can set the following environment variables:

- `HELM_VERSION` = Helm version (defaults to 2.8.1)
- `HELM_CHARTS_SOURCE` = Helm Charts source directory (defaults to `./charts`)

## Contribution

This is an open source software licensed under Apache License 2.0.
Feel free to open issues or pull requests.

