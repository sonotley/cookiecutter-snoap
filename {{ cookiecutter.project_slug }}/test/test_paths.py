import {{ cookiecutter.package_slug }}.paths as pt
import pytest
from pathlib import Path


def test_set_path_var():
    assert (
        pt.path_var_name
        == "SNOAP_" + "{{ cookiecutter.package_slug }}".upper() + "_PATH"
    )


@pytest.mark.parametrize("env_var", [(True,), (False,)])
def test_get_default_parent(env_var, monkeypatch):
    if env_var:
        test_path = "test/path"
        monkeypatch.setenv(pt.path_var_name, test_path)
        assert pt._get_default_parent() == Path(test_path)
    else:
        assert pt._get_default_parent() == Path.cwd()


@pytest.mark.parametrize(
    "env_var, getter, path_segment",
    [
        (True, pt.get_config_path, "config.{{ cookiecutter.config_file_type }}"),
        (True, pt.get_data_path, "data"),
        (True, pt.get_resources_path, "resources"),
        (False, pt.get_config_path, "config.{{ cookiecutter.config_file_type }}"),
        (False, pt.get_data_path, "data"),
        (False, pt.get_resources_path, "resources"),
    ],
)
def test_get_config_path(env_var: bool, getter, path_segment, monkeypatch):
    if env_var:
        test_path = "test/path"
        monkeypatch.setenv(pt.path_var_name, test_path)
        assert getter() == Path(Path(test_path) / path_segment).absolute()
    else:
        assert getter() == Path(Path.cwd() / path_segment).absolute()
