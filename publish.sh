#!/bin/sh
set -e
set -o pipefail

WORKING_DIRECTORY="$PWD"

[ -z "$HELM_VERSION" ] && HELM_VERSION=2.8.1
echo "HELM_VERSION=$HELM_VERSION"

[ -z "$HELM_CHARTS_SOURCE" ] && HELM_CHARTS_SOURCE="$WORKING_DIRECTORY/charts"
echo "HELM_CHARTS_SOURCE=$HELM_CHARTS_SOURCE"
[ -d "$HELM_CHARTS_SOURCE" ] || {
  echo "ERROR: Could not find Helm charts in $HELM_CHARTS_SOURCE"
  exit 1
}

echo "CIRCLE_BRANCH=$CIRCLE_BRANCH"
[ "$CIRCLE_BRANCH" ] || {
  echo "ERROR: Could not determine the current branch"
  exit 1
}

echo '>> Prepare...'
mkdir -p /tmp/helm/bin
mkdir -p /tmp/helm/publish
apk update
apk add ca-certificates git openssh

echo '>> Installing Helm...'
cd /tmp/helm/bin
wget "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxf "helm-v${HELM_VERSION}-linux-amd64.tar.gz"
chmod +x linux-amd64/helm
HELM="$PWD/linux-amd64/helm"
"$HELM" version -c
"$HELM" init -c

echo ">> Check out gh-pages branch from $CIRCLE_REPOSITORY_URL..."
cd /tmp/helm/publish
mkdir -p "$HOME/.ssh"
ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts"
git clone -b gh-pages "$CIRCLE_REPOSITORY_URL" . || {
  git init
  git checkout -b gh-pages
  git remote add origin "$CIRCLE_REPOSITORY_URL"
}

echo '>> Building charts...'
find "$HELM_CHARTS_SOURCE" -mindepth 1 -maxdepth 1 -type d | while read chart; do
  echo ">>> helm lint $chart"
  "$HELM" lint "$chart"
  echo ">>> helm package $chart"
  "$HELM" package "$chart"
done
echo '>>> helm repo index'
"$HELM" repo index .

if [ "$CIRCLE_BRANCH" != "master" ]; then
  echo "Current branch is not master and do not publish"
  exit 0
fi

echo ">> Copying .circleci/config.yml to prevent building gh-pages branch"
mkdir -p .circleci/
cp -a "$WORKING_DIRECTORY/.circleci/config.yml" .circleci/config.yml

echo ">> Publishing to $CIRCLE_REPOSITORY_URL"
git config user.email "$CIRCLE_USERNAME@users.noreply.github.com"
git config user.name CircleCI
git add .
git status
git commit -m "Published by CircleCI $CIRCLE_BUILD_URL"
git push origin gh-pages
