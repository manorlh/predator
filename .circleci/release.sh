#!/bin/sh -e

TAG=$(node -p "require('./package.json').version")

echo "Releasing tag: $TAG"

echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USER

CONTAINER_IMAGE=zooz/predator:latest
docker pull $CONTAINER_IMAGE
TAGGED_DOCKER_IMAGE=zooz/predator:$TAG
docker tag $CONTAINER_IMAGE $TAGGED_DOCKER_IMAGE
docker push $TAGGED_DOCKER_IMAGE

# Release the project tag
git tag -a "v"$TAG"" -m "New release: v"$TAG""

# Push the commit tag to gitlab
git push --follow-tags origin master

# Bump and commit the new version of package.json
npm version patch -m "v"$TAG""
git push origin master