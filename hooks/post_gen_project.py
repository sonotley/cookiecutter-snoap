import os

CONFIG_FILE_TYPES = {'yaml', 'toml', 'ini'}

REMOVE_PATHS = [f"dist/config.{x}" for x in CONFIG_FILE_TYPES - {"{{ cookiecutter.config_file_type }}"}]


for path in REMOVE_PATHS:
    path = path.strip()
    if path and os.path.exists(path):
        if os.path.isdir(path):
            os.rmdir(path)
        else:
            os.unlink(path)

# Create an empty directory for resources to be copied to the deployment target
RESOURCES_DIR = "dist/resources"

if not os.path.exists(RESOURCES_DIR):
    os.mkdir(RESOURCES_DIR)
