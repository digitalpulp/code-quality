#! /bin/sh

if [ -n ${CI_COMMIT_ID} ]; then
  git diff-tree --no-commit-id --name-only -r ${CI_COMMIT_ID} | xargs pre-commit run --files
  EXIT_CODE=$?
fi

exit $EXIT_CODE
