import subprocess
import os
import pytest
from pathlib import Path
import tempfile
import subprocess


@pytest.fixture
def temp_dir():
    with tempfile.TemporaryDirectory("cc-snoap-test") as tf:
        yield Path(tf)


def test_cookiecutter_no_hooks(temp_dir):
    """Run the cookiecutter itself with no hooks, then run the test package of the created project"""
    subprocess.run(["cookiecutter", ".", "--no-input", "-f", "-o", str(temp_dir), "--accept-hooks", "no"], check=True)
    assert os.path.exists(temp_dir / 'my-lovely-project')

    os.chdir(temp_dir / 'my-lovely-project')
    project_pytest = subprocess.run(["pytest"])
    assert project_pytest.returncode == 0

