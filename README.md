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

## Developing

Until I write some more docs here, refer to the website or just poke around to figure out what everything does.
The short version is:

- Write some code, starting from `__main__.run`
- Write some tests in the `test` module
- Run the tests in your local environment by typing `pytest`
- To build locally:
  - Run the tests with tox and perform a build if they pass by executing `./build/build.sh` 
  - If you just want a build without the tox tests, set `SNOAP_BUILD_TEST=SKIP`
  - Distribute the `dist` directory to your users.
- To build with GitHub actions
  - Push your project to GitHub, then push a tag with the version number
  - A release will be created automatically on the repo site
- Your users run the appropriate install script for their platform (only dependency is Python) and get a directory containing config file and executable
- When they double-click the executable, it executes your code starting from `__main__.run()`

