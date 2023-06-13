#!/bin/sh

set -e

SOURCE_REPO=$1
DESTINATION_REPO=$2
SOURCE_DIR=$(basename "$SOURCE_REPO")
DESTINATION_BRANCH=$3
DRY_RUN=$4


echo -e "\e[32m SOURCE: $SOURCE_REPO \e[0m"
echo -e "\e[32m DESTINATION: $DESTINATION_REPO \e[0m"
echo -e "\e[32m BRANCH: $DESTINATION_BRANCH \e[0m"
echo -e "\e[32m DRY_RUN: $DRY_RUN \e[0m"



if [ "$DESTINATION_BRANCH" != 'null' ];
then
  echo -e "\e[35m Sync branch... \e[0m"
  git clone -b "$DESTINATION_BRANCH" "$SOURCE_REPO" "$SOURCE_DIR" && cd "$SOURCE_DIR"
  git fetch "$SOURCE_REPO" "$DESTINATION_BRANCH"
  git remote set-url --push origin "$DESTINATION_REPO"

  if [ "$DRY_RUN" = "true" ]
  then
      echo "INFO: Dry Run, no data is pushed"
      git push -f "$DESTINATION_REPO" "$DESTINATION_BRANCH" --dry-run
  else
      git push -f "$DESTINATION_REPO" "$DESTINATION_BRANCH"
  fi
else
  echo -e "\e[35m Sync mirror... \e[0m"
  git clone --mirror "$SOURCE_REPO" "$SOURCE_DIR" && cd "$SOURCE_DIR"
  git remote set-url --push origin "$DESTINATION_REPO"
  git fetch -p origin
  # Exclude refs created by GitHub for pull request.
  git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin

  if [ "$DRY_RUN" = "true" ]
  then
      echo "INFO: Dry Run, no data is pushed"
      git push --mirror --dry-run
  else
      git push --mirror
  fi
fi



