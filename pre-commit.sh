#! /bin/sh
echo "Wait for the code to mount "
until [ -r .pre-commit-config.yaml ]
do
    echo "."
    sleep 2
done
echo ".pre-commit-config.yaml file is present"
if [ -n ${CI_COMMIT_ID} ]; then
  git diff-tree --no-commit-id --name-only -r ${CI_COMMIT_ID} | xargs pre-commit run --files
  EXIT_CODE=$?
fi

exit $EXIT_CODE
