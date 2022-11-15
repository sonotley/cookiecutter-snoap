import subprocess


def test_cookiecutter():
    subprocess.run(["cookiecutter", ".", "--no-input"])
