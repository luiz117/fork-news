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

curl -s \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $ACCESS_TOKEN" \
  https://api.github.com/repos/"$REPO"/pulls \
  -d "{\"head\": \"$FROM\",\"base\":\"$TO\", \"title\": \"$TITLE\", \"body\": \"$BODY\"}"
