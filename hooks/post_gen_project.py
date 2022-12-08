import os
import subprocess
import sys

# Remove config files other than the one selected (if any)
CONFIG_FILE_TYPES = {"yaml", "toml", "ini"}
CONFIG_DEPS = {"yaml": "pyyaml", "toml": "tomli"}

REMOVE_PATHS = [
    f"dist/config.{x}"
    for x in CONFIG_FILE_TYPES - {"{{ cookiecutter.config_file_type }}"}
]


for path in REMOVE_PATHS:
    path = path.strip()
    if path and os.path.exists(path):
        if os.path.isdir(path):
            os.rmdir(path)
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

# !!!Anything after this will only run if initialise_poetry=True!!!
if not {{ cookiecutter.initialise_poetry }}:
    exit(0)

# initialise as a poetry project
subprocess.run(["poetry", "init"])

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
