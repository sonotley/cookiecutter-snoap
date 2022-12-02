# cookiecutter-snoap

![example workflow](https://github.com/sonotley/cookiecutter-snoap/workflows/make-cookiecutter-and-test-installer/badge.svg)

## What is cookiecutter-snoap?

It's a [cookiecutter](https://cookiecutter.readthedocs.io/) template for [my Snakes on a Plane (snoap) workflow](https://sonotley.github.io/python-deployment-docs/).

> If you are looking for the source for the website itself, that is in a different repo [here](https://github.com/sonotley/python-deployment-docs)

## How do I use this?

First, install `cookiecutter` and `poetry`. If you use pipx, that's as simple as:

    pipx install cookiecutter
    pips install poetry

Then point cookiecutter at this repo to create a project template:

    cookiecutter cookiecutter git@github.com:sonotley/cookiecutter-snoap.git

Follow the prompts to set it up, you now have a snoap-style project with a poetry virtual environment already created for you to use in development.

## Then what?

Until I write some more docs here, refer to the website or just poke around to figure out what everything does.
The short version is:

- Write some code, starting from `__main__.run`
- Write some tests in the `test` module
- Run the tests in your local environment by typing `pytest`
- Run the tests with tox and perform a build if they pass by executing `build/build.sh`
- Distribute the `dist` directory to your users.
- Your users run the appropriate install script for their platform (only dependency is Python) and get a directory containing config file and executable
- When they double-click the executable, it executes you code starting from `__main__.run()`

