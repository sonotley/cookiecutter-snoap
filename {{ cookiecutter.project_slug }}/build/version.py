#!/usr/bin/env python3
"""Script to apply versions in projects using Poetry

Wraps `poetry version` and creates `version.txt` in each package
"""
import sys
import subprocess
import os


def write_version_to_packages(version):
    dir_list = next(os.walk(os.path.join(os.path.dirname(__file__), "..")))[1]
    for d in dir_list:
        if d[0] not in (".", "_") and os.path.exists(os.path.join(d, "__init__.py")):
            target_path = os.path.join(d, "version.txt")
            with open(target_path, 'w') as f:
                f.write(version)


if len(sys.argv) > 2:
    print("Too many arguments")

else:
    if len(sys.argv) > 1:
        subprocess.run(["poetry", "version", sys.argv[1]])
    else:
        subprocess.run(["poetry", "version"])
    current_version = subprocess.check_output(["poetry", "version"]).decode(sys.stdout.encoding).strip()
    write_version_to_packages(current_version)


