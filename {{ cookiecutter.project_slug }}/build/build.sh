#!/usr/bin/env bash

set -e
poetry export -f requirements.txt --output dist/requirements.txt
poetry export -f requirements.txt --with dev --output build/requirements-with-dev.txt

if [ "$SNOAP_BUILD_TEST" = "GLOBAL_TOX" ]
then
  tox
elif [ "$SNOAP_BUILD_TEST" = "GLOBAL_PYTEST" ]
then
  pytest
elif [ "$SNOAP_BUILD_TEST" = "PROJ_PYTEST" ] || [ "$SNOAP_BUILD_TEST" = "PYTEST" ]
then
  poetry run pytest
elif [ "$SNOAP_BUILD_TEST" = "PROJ_TOX" ] || [ "$SNOAP_BUILD_TEST" = "TOX" ] || [ -z "$SNOAP_BUILD_TEST"]
then
  poetry run tox
elif [ "$SNOAP_BUILD_TEST" = "SKIP" ]
then
  echo Tests skipped due to SNOAP_BUILD_TEST setting
else
  echo WARNING! Unknown SNOAP_BUILD_TEST argument supplied, tests skipped!
fi
poetry build