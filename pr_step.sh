#!/bin/bash
#
# Creates a PR based on the input values
#

readonly ACCESS_TOKEN=$1
readonly REPO=$2
readonly FROM=$3
readonly TO=$4
readonly TITLE=$5
readonly BODY=$6
readonly USERS=$7

readonly fork_news_pr=$(curl -s \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $ACCESS_TOKEN" \
  https://api.github.com/repos/"$REPO"/pulls \
  -d "{\"head\": \"$FROM\",\"base\":\"$TO\", \"title\": \"$TITLE\", \"body\": \"$BODY\"}")

readonly pr_id=$(echo "$fork_news_pr" | jq -r .number)
curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $ACCESS_TOKEN" \
  https://api.github.com/repos/"$REPO"/issues/"$pr_id"/comments \
  -d "{\"body\":[\"@$USERS\"]}"
