# cookiecutter-snoap

![example workflow](https://github.com/sonotley/cookiecutter-snoap/workflows/make-cookiecutter-and-test-installer/badge.svg)

This project is provided under the BSD 3-clause license, copyright Simon Notley 2023.

## What is cookiecutter-snoap?

It's a [cookiecutter](https://cookiecutter.readthedocs.io/) template for my _snoap_ workflow.

Snoap (SNakes On A Plane or Simon NOtley APp depending on your appetite for copyright infringement) is
an opinionated workflow for developing and distributing Python applications. 
It aims to make Python applications more like 'normal' Mac or Windows desktop applications. 
Your application will be packaged into a zip file containing an installer which will install the 
application into a single directory including a double-clickable executable and a config file.

You can read more about why I devised snoap and the choices I made [here](https://sonotley.github.io/python-deployment-docs/).

If you are looking for the source for the website itself, that is in a different repo [here](https://github.com/sonotley/python-deployment-docs)

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
- Populate the config file and the `data` and `resources` directories if/as required for your application
  - Use the functions provided in the `paths` module to refer to these file locations
- Write some tests in the `test` module
- Run the tests in your local environment by typing `pytest`
- Advance the version number by running `./build/version.py [major/minor/patch]`
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
├── build/
│   ├── build.sh
│   └── version.py
├── dist/
│   ├── config.yaml
│   ├── data/
│   ├── install_on_linux.sh
│   ├── install_on_windows.cmd
│   ├── readme.md
│   ├── readme_for_app.md
│   └── resources/
├── my_lovely_project/
│   ├── __init__.py
│   ├── __main__.py
│   ├── _options.py
│   ├── paths.py
│   └── version.txt
├── pyproject.toml
├── readme.md
├── test/
│   ├── __init__.py
│   ├── test_paths.py
│   └── version.txt
└── tox.ini

```

### The `build` directory

This directory contains scripts related to building the project. 

`build.sh` is a shell script which calls tox to run the tests, then poetry to export requirements files and build the package.

`version.py` is a Python script which is used to update the version number of your project.
It wraps `poetry version` so takes the same arguments. 
The reason for this wrapper is to ensure the version number is written to `version.txt` as well as `pyproject.toml`. 
This, together with some boilerplate code in `__init.py__` makes it possible to get the version number at runtime using the module-level `__version__` attribute.

### The `dist` directory

This directory contains files that will be included as-is in the distribution you provide to your end users. This includes:

- Two installation scripts, one for Windows (in `cmd`) and one for Linux (in `bash`)
- A `readme.md` file. This will be the readme your users see _before_ installing your application.
- A `readme_for_app.md` file. This will be renamed to `readme.md` and included in the installation location, so it should contain instructions for use.
- A configuration file in the format you selected (unless you selected 'none')
- A `resources` directory. This is where you should put any non-Python files that your application needs.
- A `data` directory. This is where your program should write frequently-changing data like caches, downloads etc.

### The package directory

This directory is named using the `package_slug` parameter you specified. It is where all your Python code should reside.
This package will be built and included in your distribution along with the files in the `dist` directory. 
There are some Python modules included in the package by default.

- `__init__.py` marks this directory as being a Python package. It also contains boilerplate code to read the version number from `version.txt` and assign it to module variable `__version__`
- `__main__.py` is the entry point for your application, specifically the function `run`. This will be called when your application is executed.
- `_options.py` is populated automatically by the installer. It is used by `paths.py` to determine at runtime how and where the application was installed.
- `paths.py` provides a set of functions that return paths to the configuration file, `data` and `resources` directories
- `version.txt` contains the version number of your package. Don't change this manually, it's managed by `build/version.py`

### The `test` directory

This is where you write tests. At first, it will just have an `__init__.py` and `version.txt` same as the package directory. 
You can add as many test modules as you need, just follow the [conventions for auto discovery in pytest](https://docs.pytest.org/en/7.2.x/explanation/goodpractices.html#test-discovery)

These tests will be run by tox before your project is built.

### Top-level files

In addition to the directories described above, the project contains the following files:

- `pyproject.toml` a standard file used by Python packaging tools (in this case Poetry) to store and retrieve package metadata.
- `tox.ini` defines what environments tox will use to run the tests. This is automatically populated based on your specified min and max Python versions.
- `readme.md` is the readme for the project. This is what will appear on the repo page in GitHub so it should contain information for developers and users.

## Tips & Troubleshooting

### What does the `paths` module do if I just run the code without installing (from IDE/debugger for example)?

All of the `paths` functions will return the current working directory in this case.

#### But my config/data/resources isn't in the same directory as my code!

In most IDEs you can specify the working directory to be used when you click 'run' or 'debug' so just set that to wherever you are keeping those files.

#### I'm not using an IDE, I'm running from terminal.

You can invoke the app from terminal during development with the command from the directory containing `pyproject.toml`.
But if this directory isn't where your config/data/resources are located things won't work well.

    poetry run python -m your_package_name

You can overcome this by setting the environment variable `SNOAP_YOUR_PACKAGE_NAME_PATH` to an absolute path, or path relative to your working directory.

    SNOAP_YOUR_PACKAGE_NAME_PATH = '.local' poetry run python -m your_package_name

### I installed an app using snoap then one day it stopped working with some cryptic error about `encodings`!

This can happen if the Python installation that was used to create the virtual environment no longer exists or cannot be found.
This is far more likely to happen on Windows where there is no 'system' Python. It can happen in various scenarios:

- Python was installed for the user who performed the installation only and that user account has been deleted
- A newer version of Python was installed and the old version was deleted

It can also happen on Linux if you use something like `pyenv` to run multiple Python versions and you have removed the version that was used for installation.

The installer automatically creates a script with prefix `refresh_` in the `bin` directory which you can run to refresh the app in this instance.

