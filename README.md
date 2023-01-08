# cookiecutter-snoap

![example workflow](https://github.com/sonotley/cookiecutter-snoap/workflows/make-cookiecutter-and-test-installer/badge.svg)

## What is cookiecutter-snoap?

It's a [cookiecutter](https://cookiecutter.readthedocs.io/) template for my _snoap_ workflow.

Snoap (SNakes On A Plane or Simon NOtley APp depending on your appetite for copyright infringement) is
an opinionated workflow for developing and distributing Python applications. 
It aims to make Python applications more like 'normal' Mac or Windows desktop applications. 
Your application will be packaged into a zip file containing an installer which will install the 
application into a single directory including a double-clickable executable and a config file.

You can read more about why I devised snoap and the choices I made [here](https://sonotley.github.io/python-deployment-docs/).

> If you are looking for the source for the website itself, that is in a different repo [here](https://github.com/sonotley/python-deployment-docs)

## Prerequisites

You'll need to install Cookiecutter and Poetry. If you use pipx, that's as simple as:

    pipx install cookiecutter
    pipx install poetry

Cookiecutter is used to create the project structure and boilerplate code for you from this repo. 
You'll be using Poetry to manage your development environment and dependencies as you write your application.

## Creating a new project

Simply point cookiecutter at this repo to create a fresh project template:

    cookiecutter git@github.com:sonotley/cookiecutter-snoap.git

Follow the prompts to set it up, you now have a snoap project with a Poetry virtual environment already created for you to use in development.

### Project parameters
| Parameter                  | Example value                 | Description                                                                                                                                                    |
|----------------------------|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| project_name               | My lovely project             | The name of your project with caps and spaces as it should appear in docs                                                                                      |
| project_slug               | my-lovely-project             | The name of the project to be used in the executable path and other such places                                                                                |
| package_slug               | my_lovely_project             | The name of the Python package that will contain your code                                                                                                     |
| description                | A project for Europe          | A description used in docs and package metadata                                                                                                                |
| author                     | Simon Notley                  | Used in package metadata                                                                                                                                       |
| license                    | MIT                           | Used in package metadata                                                                                                                                       |
| python_min_version         | 3.8                           | Used to determine what interpreters to test with and for dependency resolution. <br/>Think carefully about this value as it will be enforced by the installer. |
| python_max_version         | 3.11                          | Used to determine what interpreters to test with and for dependency resolution. <br/>Unlike min version, this is not currently enforced by the installer.      |
| config_file_type           | "none", "yaml", "toml", "ini" | A file of the selected type will be added to your project and appropriate parser included.                                                                     |
| initialise_poetry          | y/n or True/False or similar  | If true, a Poetry virtual environment will be created automatically with core runtime and test dependencies installed.                                         |
| include_github_autorelease | y/n or True/False or similar  | Include a .github directory containing an automatic test, build and release action.                                                                            |

## Developing with snoap

The snoap development workflow looks like this:

- Write some code, starting from `__main__.run`
- Write some tests in the `test` module
- Run the tests in your local environment by typing `pytest`
- Advance the version number by running `./`
- To build locally:
  - Run the tests with tox and perform a build if they pass by executing `./build/build.sh` 
  - If you just want a build without the tox tests, set `SNOAP_BUILD_TEST=SKIP`
  - Distribute the `dist` directory to your users.
- To build with GitHub actions
  - Push your project to GitHub, then push a tag with the version number
  - A release will be created automatically on the repo site
- Your users run the appropriate install script for their platform (only dependency is Python) and get a directory containing config file and executable
- When they double-click the executable, it executes your code starting from `__main__.run()`

## Anatomy of a snoap project

After running the cookiecutter, you'll have a project something like this, depending on your choices.

```commandline
my-lovely-project
├── build
│   ├── build.sh
│   └── version.py
├── dist
│   ├── config.yaml
│   ├── data
│   ├── install_on_linux.sh
│   ├── install_on_windows.cmd
│   ├── readme.md
│   ├── readme_for_app.md
│   └── resources
├── my_lovely_project
│   ├── __init__.py
│   ├── __main__.py
│   ├── _options.py
│   ├── paths.py
│   └── version.txt
├── pyproject.toml
├── readme.md
├── test
│   ├── __init__.py
│   ├── test_paths.py
│   └── version.txt
└── tox.ini

```

### The build directory

This directory contains scripts related to building the project. 

`build.sh` is a shell script which calls tox to run the tests, then poetry to export requirements files and build the package.

`version.py` is a Python script which is used to update the version number of your project.
It wraps `poetry version` so takes the same arguments. 
The reason for this wrapper is to ensure the version number is written to `VERSION.TXT` as well as `pyproject.toml`. 
This, together with some boilerplate code in `__init.py__` makes it possible to get the version number at runtime using the module-level `__version__` attribute.