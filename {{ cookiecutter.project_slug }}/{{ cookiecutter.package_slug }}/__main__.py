{% if cookiecutter.config_file_type == "yaml" %}import pyyaml{% endif %}
{% if cookiecutter.config_file_type == "toml" %}import tomli{% endif %}

def run():
    ...
