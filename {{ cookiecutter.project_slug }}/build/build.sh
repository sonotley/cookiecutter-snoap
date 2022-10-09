#!/usr/bin/env bash

poetry export -f requirements.txt --output dist/requirements.txt
tox || { echo "TESTS FAILED - BUILD ABORTED" ; exit 1; }
echo "Test passed - building sdist and wheel"
poetry build || { echo "POETRY BUILD FAILED - BUILD ABORTED" ; exit 1; }