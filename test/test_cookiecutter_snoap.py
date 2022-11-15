import subprocess
import os
import sys


def test_cookiecutter():
    """Test that no errors are thrown running the cookiecutter itself, also forms the setup for following tests"""
    subprocess.run(["cookiecutter", ".", "--no-input", "-f"], check=True)
    assert os.path.exists('my-lovely-project')


def test_install():
    if sys.platform == "linux":
        subprocess.run(["sh", "my-lovely-project/dist/install_on_linux.sh"], check=True)
    elif sys.platform == "darwin":
        subprocess.run(["sh", "my-lovely-project/dist/install_on_linux.sh", "~"], check=True)
