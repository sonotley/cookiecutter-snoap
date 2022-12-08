import {{ cookiecutter.package_slug }}.paths as pt
from pathlib import Path

def test_get_config_path():
    assert(pt.get_config_path() == Path(Path.cwd() / "config.{{ cookiecutter.config_file_type }}").absolute())

def test_get_resources_path():
    assert(pt.get_resources_path() == Path(Path.cwd() / "resources").absolute())

def test_get_data_path():
    assert(pt.get_data_path() == Path(Path.cwd() / "data").absolute())