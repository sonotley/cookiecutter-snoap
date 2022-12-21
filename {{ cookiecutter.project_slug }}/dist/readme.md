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

In-place upgrades are experimentally supported. You can try just running the new installer with the same filepath
and it _shouldn't_ overwrite any of your config, resources or data. However, always backup first! 

If that doesn't work just delete the old version, install the new version, then copy across anything that you need from
your backup before deleting it.

Neither of these methods makes any attempt to 'upgrade' your files so if the new version expects a different config file
or different data/resources you'll need to make those changes and/or delete the old stuff manually.