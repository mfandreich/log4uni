#!/bin/sh
TAG_NAME=$(strings ./Build/Release/log4uni.dll | egrep '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | egrep -o '^[0-9]+\.[0-9]+\.[0-9]+' ) 
echo "Target version tag name $TAG_NAME"
git subtree split -P Build/Release -b upm
TAG_BRANCH_COMMIT=$(git log -n 1 upm --pretty=format:"%H")
echo "Git subtree commit $TAG_BRANCH_COMMIT"
git push -f origin upm
EXISTING_TAG=$(git tag -l $TAG_NAME)
echo "Existing version tag name $EXISTING_TAG"
