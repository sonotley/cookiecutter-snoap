import os
import subprocess
import sys
import shutil


def resolve_boolean(val):
    if isinstance(val, bool):
        return val
    if isinstance(val, str) and val.lower() in ("y", "yes", "true", "t", "1"):
        return True
    if val == 1:
        return True
    return False


# Remove config files other than the one selected (if any)
CONFIG_FILE_TYPES = {"yaml", "toml", "ini"}
CONFIG_DEPS = {"yaml": "pyyaml", "toml": "tomli"}

REMOVE_PATHS = [
    f"dist/config.{x}"
    for x in CONFIG_FILE_TYPES - {"{{ cookiecutter.config_file_type }}"}
]

if not resolve_boolean("{{ cookiecutter.include_github_autorelease }}"):
    REMOVE_PATHS.append(".github")

for path in REMOVE_PATHS:
    path = path.strip()
    if path and os.path.exists(path):
        if os.path.isdir(path):
            shutil.rmtree(path)
        else:
            os.unlink(path)

# Create an empty directory for resources and data to be copied to the deployment target
RESOURCES_DIR = "dist/resources"
DATA_DIR = "dist/data"

if not os.path.exists(RESOURCES_DIR):
    os.mkdir(RESOURCES_DIR)

if not os.path.exists(DATA_DIR):
    os.mkdir(DATA_DIR)

if sys.platform in ("linux", "darwin"):
    subprocess.run(["chmod", "+x", "dist/install_on_linux.sh"])
    subprocess.run(["chmod", "+x", "build/build.sh"])
    subprocess.run(["chmod", "+x", "build/version.py"])

# !!!Anything after this will only run if initialise_poetry=True!!!
if not resolve_boolean("{{ cookiecutter.initialise_poetry }}"):
    exit(0)

# Set poetry to keep its venv in the local directory
subprocess.run(["poetry", "config", "--local", "virtualenvs.in-project", "true"])

# initialise as a poetry project
subprocess.run(["poetry", "install"])

# add dev dependencies
subprocess.run(
    ["poetry", "add", "tox", "pytest", "pytest-cov", "pytest-mock", "-G", "dev"]
)

# Add config file parsing dependencies if any
try:
    config_dep = CONFIG_DEPS["{{ cookiecutter.config_file_type }}"]
except KeyError:
    config_dep = None

if config_dep:
    subprocess.run(["poetry", "add", config_dep])
