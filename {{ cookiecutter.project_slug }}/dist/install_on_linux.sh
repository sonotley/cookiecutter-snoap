#!/usr/bin/env bash

printRule () {
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "$1"
}

bold=$(tput bold)
normal=$(tput sgr0)
yellow=$(tput setaf 3)
green=$(tput setaf 2)

set -e
printRule '-'
echo ${bold}Installing {{ cookiecutter.project_name }}${normal}
printRule '-'
targetParentDir="${1:-'/opt'}"
targetDir="$targetParentDir/{{ cookiecutter.project_slug }}"
sourceDir="$(dirname "$0")"
echo Installing from "$sourceDir" to "$targetDir"

# Create and activate a Python venv
echo Building Python virtual environment
echo Using interpreter $(which python3)
python3 -m venv "$targetDir"/env --clear
tmp=("$sourceDir"/{{ cookiecutter.package_slug }}*.whl)
wheel="${tmp[0]}"
source "$targetDir"/env/bin/activate

# Install the pinned dependencies from requirements.txt, then install the wheel
python3 -m pip install --upgrade pip
python3 -m pip install -Ur "$sourceDir"/requirements.txt || { echo Installation with pinned dependencies failed, attempting local dependency resolution; pinFail=1;}
python3 -m pip install "$wheel"

# Create links to the binary for convenience, one at top level and one in a bin directory
ln -sf "$targetDir"/env/bin/{{ cookiecutter.project_slug }} "$targetDir"/{{ cookiecutter.project_slug }}
mkdir -p "$targetDir"/bin
ln -sf "$targetDir"/env/bin/{{ cookiecutter.project_slug }} "$targetDir"/bin/{{ cookiecutter.project_slug }}

# Copy files from installer directory to their target locations
{% if cookiecutter.config_file_type != "none" %}cp -n "$sourceDir"/config.{{ cookiecutter.config_file_type }} "$targetDir"/config.{{ cookiecutter.config_file_type }}{% endif %}
mkdir -p "$sourceDir"/data
mkdir -p "$sourceDir"/resources
cp -rn "$sourceDir"/data "$targetDir"/data
cp -rn "$sourceDir"/resources "$targetDir"/resources
cp "$sourceDir"/readme_for_app.md "$targetDir"/readme.md

# Record details of installation method in a Python module accessible at run-time
echo 'install_method, install_target = "one_dir","'"$targetDir"'"' > "$targetDir"/env/lib/python*/site-packages/{{ cookiecutter.package_slug }}/_options.py

if [[ $sourceDir != $targetDir/install ]]
then
  # Save the installer near the app
  [ -d "$targetDir"/install ] && rm -r "$targetDir"/install
  mkdir "$targetDir"/install
  cp -r "$sourceDir"/* "$targetDir"/install

  # Create a script to refresh the app if it gets broken by Python env changes for example
  refreshScript="$targetDir"/bin/refresh-{{ cookiecutter.project_slug }}.sh
  echo '#!/usr/bin/env bash' > "$refreshScript"
  echo "bash $targetDir/install/install_on_linux.sh $targetParentDir" >> "$refreshScript"
  chmod +x "$refreshScript"
fi

printRule '='
echo ${bold}Installation complete${normal}
if [[ $pinFail = 1 ]]
then
  echo ${yellow}WARNING: pinned versions of dependencies could not be installed. Instead dependency resolution was performed by pip, it will probably work but is not exactly as tested.${normal}
fi
if [[ $PATH != *:$targetDir/bin* ]]
then
  echo ${green}Consider adding "$targetDir"/bin to your PATH for quick access to {{ cookiecutter.project_name }}${normal}
fi
printRule '='