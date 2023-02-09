from pathlib import Path
import {{ cookiecutter.package_slug }}._options as options
import os

project_name = "{{ cookiecutter.project_slug }}"
install_method = options.install_method
install_target = Path(options.install_target)
path_var_name = "SNOAP_" + "{{ cookiecutter.package_slug }}".upper() + "_PATH"


def get_config_path():
    config_file_name = "config.{{cookiecutter.config_file_type}}"

    return _get_path(config_file_name, linux_loc=Path("/etc/opt"))


def get_resources_path():
    return _get_path("resources/", linux_loc=Path("/etc/opt"))


def get_data_path():
    return _get_path("data/", linux_loc=Path("/var/opt"))


def _get_path(item: str, linux_loc: Path):
    if install_method == "one_dir":
        return install_target / item

    if install_method == "linux":
        return linux_loc / project_name / item

    return Path(_get_default_parent() / item).absolute()


def _get_default_parent():
    if os.getenv(path_var_name, default="") != "":
        return Path(os.environ[path_var_name])

    return Path.cwd()
