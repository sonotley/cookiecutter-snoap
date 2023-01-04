#!/usr/bin/env bash

set -e
poetry export -f requirements.txt --output dist/requirements.txt
poetry export -f requirements.txt --with dev --output build/requirements-with-dev.txt

# shellcheck disable=SC1019
# shellcheck disable=SC1073
if [ "$SNOAP_BUILD_TEST" = "GLOBAL_TOX" ]
then
  tox
elif [ "$SNOAP_BUILD_TEST" = "GLOBAL_TOX_SKIPMISSING" ]
then
  tox --skip-missing-interpreters
elif [ "$SNOAP_BUILD_TEST" = "GLOBAL_PYTEST" ]
then
  pytest
elif [ "$SNOAP_BUILD_TEST" = "PROJ_PYTEST" ] || [ "$SNOAP_BUILD_TEST" = "PYTEST" ]
then
  poetry run pytest
elif [ "$SNOAP_BUILD_TEST" = "PROJ_TOX" ] || [ "$SNOAP_BUILD_TEST" = "TOX" ] || [ -z "$SNOAP_BUILD_TEST"]
then
#  This is the default behaviour, run tox from Poetry to be sure it exists
  poetry run tox
elif [ "$SNOAP_BUILD_TEST" = "PROJ_TOX_SKIPMISSING" ] || [ "$SNOAP_BUILD_TEST" = "TOX_SKIPMISSING" ]
then
  poetry run tox --skip-missing-interpreters
elif [ "$SNOAP_BUILD_TEST" = "SKIP" ]
then
  echo Tests skipped due to SNOAP_BUILD_TEST setting
else
  echo WARNING! Unknown SNOAP_BUILD_TEST argument supplied, tests skipped!
fi
poetry build