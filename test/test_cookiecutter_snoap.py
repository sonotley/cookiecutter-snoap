import subprocess
import os
import pytest
from pathlib import Path
import tempfile


@pytest.fixture
def temp_dir():
    with tempfile.TemporaryDirectory("cc-snoap-test") as tf:
        yield Path(tf)


def test_cookiecutter_no_hooks(temp_dir):
    """Test that no errors are thrown running the cookiecutter itself with no hooks"""
    subprocess.run(["cookiecutter", ".", "--no-input", "-f", "-o", str(temp_dir), "--accept-hooks", "no"], check=True)
    assert os.path.exists(temp_dir / 'my-lovely-project')


# def test_install():
#     if sys.platform == "linux":
#         # Assumes existence of bash
#         subprocess.run(["/bin/bash", "my-lovely-project/dist/install_on_linux.sh"], check=True)
#     elif sys.platform == "darwin":
#         # may well fail on zsh
#         subprocess.run(["sh", "my-lovely-project/dist/install_on_linux.sh", "~"], check=True)
