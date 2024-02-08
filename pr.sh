#!/bin/bash

set -e

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN input is required"
  exit 1
fi

if [ -z "$BODY" ]; then
  echo "Error: body input is required"
  exit 1
fi

# Get pull request number
PR_NUMBER=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

if [ "$PR_NUMBER" == "null" ]; then
  echo "Error: No pull request found"
  exit 1
fi

# Fetch current pull request details
CURRENT_BODY=$(gh pr view $PR_NUMBER --json body -q .body)
echo "DEBUG: CURRENT_BODY=$CURRENT_BODY"
echo "DEBUG: BODY=$BODY"

# Normalize the formatting of the new body for comparison
NORMALIZED_BODY=$(echo "$BODY" | sed 's/ *//g' | tr -d '\n')
echo "DEBUG: NORMALIZED_BODY=$NORMALIZED_BODY"

# Check if newBody already exists in the current description
if ! echo "$CURRENT_BODY" | sed 's/ *//g' | tr -d '\n' | grep -Fq "$NORMALIZED_BODY"; then
#if ! echo "$CURRENT_BODY" | grep -Fq "$BODY"; then
  # Concatenate the new text to the existing description
  COMBINED_BODY="${CURRENT_BODY} ${BODY}"

  gh pr edit $PR_NUMBER --body "${COMBINED_BODY}"

  echo "Updated pull request description."
else
  echo "New body already exists in the current description. No update needed."
fi
