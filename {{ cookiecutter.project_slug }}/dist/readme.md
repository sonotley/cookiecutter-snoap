# {{ cookiecutter.project_name }}

## What is {{ cookiecutter.project_name }}?

{{ cookiecutter.description }}

## How to install {{ cookiecutter.project_name }}

> This installation method requires Python {{ cookiecutter.python_min_version }}+ to be installed and on the PATH. It also requires internet connectivity.

Simply run the installation script for your operating system. Optionally you may supply the installation location as an argument.
For example `install_on_windows.cmd C:\imcity`. Do not add a trailing slash.

If installed without specifying a location the default locations are:

Windows: `C:`

Debian: `/opt`

The installer will create a directory `{{ cookiecutter.project_slug }}` in the chosen location. This will contain 

- an executable `{{ cookiecutter.project_slug }}`
{% if cookiecutter.config_file_type != "none" %}- a configuration file config.{{ cookiecutter.config_file_type }}{% endif %}

### Uninstalling

To uninstall simply delete the installation directory

### Updating

To update, rename your current installation folder, install the new version, then copy across anything that you need from the
old one before deleting it.