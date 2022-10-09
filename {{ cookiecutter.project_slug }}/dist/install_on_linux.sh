#!/usr/bin/env bash
set -e
echo "*************************"
echo "Installing {{ cookiecutter.project_name }}"
echo "*************************"
filePath=${1:-"/opt"}/{{ cookiecutter.project_slug }}
echo "Installing to $filePath"
echo "Building Python virtual environment"
python3 -m venv "$filePath"/env
target=("$(dirname "$0")"/{{ cookiecutter.package_slug }}*.whl)
source "$filePath"/env/bin/activate
pip install -Ur "${target[0]}"/requirements.txt || { echo Installation with pinned dependencies failed, attempting local dependency resolution; pinFail=1;}
pip install "${target[0]}"
ln -s "$filePath"/env/bin/{{ cookiecutter.project_slug }} "$filePath"/{{ cookiecutter.project_slug }}
cp "$(dirname "$0")"/config.yaml "$filePath"/config.yaml
echo "*******************************"
echo "Installation complete"
if [ $pinFail == 1 ]
then
  echo WARNING: pinned versions of dependencies could not be installed. Instead dependency resolution was performed by pip, it will probably work but is not exactly as tested.
fi
echo "*******************************"