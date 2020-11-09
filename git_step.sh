#!/bin/bash
#
# Creates a merge branch on the repository REPO_NAME when FROM_REPO/FROM_BRANCH
# is ahead of TO_BRANCH.
#

# Arguments
readonly ACCESS_TOKEN=$1
readonly REPO_NAME=$2
readonly TO_BRANCH=$3
readonly FROM_REPO=$4
readonly FROM_BRANCH=$5

# Configuration
readonly PARENT_UPSTREAM_REPO='fork-upstream'
readonly REMOTE_ORIGIN='origin'
readonly REMOTE_UPSTREAM='upstream'
readonly CHANGES_THRESHOLD=0
readonly REPO_FOLDER='tmp-repo'
readonly REPO_URL_TEMPLATE="https://$ACCESS_TOKEN@github.com/REPO.git"
readonly NO_CHANGES=0
readonly GIT_ERROR=2
readonly FILE_ERROR=3
readonly FORK_ERROR=4

# Clone the current repo
readonly current_repo_url=${REPO_URL_TEMPLATE/REPO/"$REPO_NAME"}
if ! git clone -q \
    -b "$TO_BRANCH" \
    "$current_repo_url" "$REPO_FOLDER"; then
    exit "$GIT_ERROR"
fi
cd "$REPO_FOLDER" || exit "$FILE_ERROR"

# Find the source repo
source_repo_name="$FROM_REPO"
if [[ "$source_repo_name" == "$PARENT_UPSTREAM_REPO" ]]; then
    readonly repo_data=$(
        curl -s -H "Authorization: token ${ACCESS_TOKEN}" \
            "https://api.github.com/repos/$REPO_NAME"
    )
    readonly is_fork=$(echo "$repo_data" | jq -r .fork)
    if [[ "$is_fork" = false ]]; then
        echo 'This repository is not a fork. Specify the from-repo value.'
        exit "$FORK_ERROR"
    fi

    source_repo_name=$(echo "$repo_data" | jq -r .parent.full_name)
fi
readonly source_repo_url=${REPO_URL_TEMPLATE/REPO/"$source_repo_name"}

# Update current state
readonly timestamp=$(date +%s)
git checkout -q "$BRANCH"
git fetch -q "$REMOTE_ORIGIN"

# Add and update the upstream
git remote add "$REMOTE_UPSTREAM" "$source_repo_url"
git fetch -q "$REMOTE_UPSTREAM"

readonly changes_ahead=$(
    git rev-list --count "$TO_BRANCH".."$REMOTE_UPSTREAM/$FROM_BRANCH"
)
if [[ ${changes_ahead} -le ${CHANGES_THRESHOLD} ]]; then
    echo 'No changes to merge.'
    exit "$NO_CHANGES"
fi

# Checkout and merge
readonly temp_branch="fork-news-temp-${BRANCH}-${timestamp}"
readonly fork_news_branch="fork-news-${BRANCH}-${timestamp}"
git checkout -q -b "$temp_branch" "$REMOTE_UPSTREAM/$FROM_BRANCH"
git checkout -q -b "$fork_news_branch"
git clean -f -d -q

git merge -q --no-edit --allow-unrelated-histories "$temp_branch"
git add -A
git commit -q -m "Fork news" --allow-empty
git push -q -u "$REMOTE_ORIGIN" "$fork_news_branch"

# Clean up
git remote remove "$REMOTE_UPSTREAM"
git branch -q -D "$temp_branch"
cd ..
rm -rf "$REPO_FOLDER"

# Print the merge branch
echo "::set-output name=fork-news-branch::$fork_news_branch"
