#!/bin/sh
TAG_NAME=$(strings ./Build/Release/log4uni.dll | egrep '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | egrep -o '^[0-9]+\.[0-9]+\.[0-9]+' ) 
echo "Target version tag name $TAG_NAME"
git subtree split -P Build/Release -b upm
TAG_BRANCH_COMMIT=$(git log --max-count=1 --pretty=format:"%H" upm --)
echo "Git subtree commit $TAG_BRANCH_COMMIT"
git push -f origin upm
EXISTING_TAG=$(git tag -l $TAG_NAME)
echo "Existing version tag name $EXISTING_TAG"
if [$EXISTING_TAG = $TAG_NAME]
then
  echo "Git tag $TAG_NAME already exists. Skip."
  echo "RELEASE_TAG=NOT_RELEASE" >> $GITHUB_ENV
else
  echo "Create git tag $TAG_NAME on $TAG_NAME $TAG_BRANCH_COMMIT."
  git tag -a $TAG_NAME $TAG_BRANCH_COMMIT -m "version $TAG_NAME tag"  
  git push origin $TAG_NAME
  echo "RELEASE_TAG=$TAG_NAME" >> $GITHUB_ENV
fi
