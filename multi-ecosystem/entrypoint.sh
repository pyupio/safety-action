#!/usr/bin/env bash
set -eu -o pipefail

# Early out if the API key is not set
if [[ "${SAFETY_API_KEY:-}" == "" ]]; then
    echo "[Safety Action] An API key is required to use this action. Please sign up for an account at https://safetycli.com/" 1>&2
    exit 1
fi

export SAFETY_OS_TYPE="docker action"
export SAFETY_OS_RELEASE=""
export SAFETY_OS_DESCRIPTION=""

if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
  SAFETY_GIT_BRANCH=$(jq --raw-output .pull_request.head.ref "$GITHUB_EVENT_PATH")
  SAFETY_GIT_COMMIT=$(jq -r ".pull_request.head.sha" $GITHUB_EVENT_PATH)
else
  SAFETY_GIT_BRANCH=${GITHUB_REF#refs/heads/}
  SAFETY_GIT_COMMIT=$GITHUB_SHA
fi

if [[ $GITHUB_REF == refs/tags/* ]]; then
  SAFETY_GIT_TAG=${GITHUB_REF#refs/tags/}
else
  SAFETY_GIT_TAG=""
fi

# Set up Git configuration to enable certain git commands within the GitHub Actions environment
git config --system --add safe.directory /github/workspace

# Check if debug mode is enabled
if [[ "${SAFETY_DEBUG:-}" == "true" ]]; then
    echo "Action running in debug mode, debug info"
    echo "-----------------------------------------"

    echo "GitHub Action debug information:"
    echo "GITHUB_EVENT_NAME: $GITHUB_EVENT_NAME"
    echo "GITHUB_REF: $GITHUB_REF"
    echo "Git remote origin: $(git remote get-url origin)"
    echo "Git branch: $SAFETY_GIT_BRANCH"
    echo "Git commit: $SAFETY_GIT_COMMIT"
    if [[ $GITHUB_REF == refs/tags/* ]]; then
        echo "Git tag: $SAFETY_GIT_TAG"
    else
        echo "Git tag: not a tag event"
    fi
    echo "-----------------------------------------"

    # Set the debug argument for the Safety CLI
    echo "Running \"safety scan\" in debug mode:"
    SAFETY_DEBUG_ARG="--debug"
else
    SAFETY_DEBUG_ARG=""
fi

echo "Safety Action version: $SAFETY_ACTION_VERSION"
echo "Safety CLI version: $(python -m safety --version)"

# Export environment variables for use by the Safety CLI
export SAFETY_GIT_BRANCH=$SAFETY_GIT_BRANCH
export SAFETY_GIT_COMMIT=$SAFETY_GIT_COMMIT
export SAFETY_GIT_TAG=$SAFETY_GIT_TAG

# Don't hard fail from here on out; so we can return the exit code and output
set +e

# Process the output of Safety CLI for proper display in GitHub Actions
# This involves removing special characters and encoding multi-line strings
# This also sends the output to both stdout and our variable, without buffering like echo would.
# sed -E ':a;N;$!ba;s/\n{3,}/\n\n/g'       replace any occurrence of three or more newlines (\n{3,}) with exactly two newlines (\n\n)
# sed -E 's/\x1b\[\??25[lh]//g'            remove certain ANSI escape codes related to cursor control (like hiding/showing the cursor) from the output of a command
exec 5>&1
output=$(python -m safety ${SAFETY_DEBUG_ARG} --stage cicd scan --output="${SAFETY_ACTION_OUTPUT_FORMAT}" ${SAFETY_ACTION_ARGS} | stdbuf -o0 sed -E 's/\x1b\[\??25[lh]//g' | sed -E ':a;N;$!ba;s/\n{3,}/\n\n/g' | tee >(cat - >&5))
exit_code=$?

# https://github.community/t/set-output-truncates-multiline-strings/16852/3
# Encoding for GitHub Actions to handle multi-line strings and special characters
output="${output//'%'/'%25'}"    # Replace % with %25
output="${output//$'\n'/'%0A'}"  # Replace newline characters with %0A
output="${output//$'\r'/'%0D'}"  # Replace carriage return characters with %0D

# Output the exit code and CLI output for GitHub Actions to consume
echo "exit-code=$exit_code" >> $GITHUB_OUTPUT
echo "cli-output=$output" >> $GITHUB_OUTPUT

# Exit with the same code as the Safety CLI command
exit $exit_code