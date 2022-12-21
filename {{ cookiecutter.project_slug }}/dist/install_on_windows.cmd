@echo off
echo *************************
echo Installing {{ cookiecutter.project_name }}
echo *************************
IF %1.==. set filePath=C:\{{ cookiecutter.project_slug }}& GOTO install
set filePath=%1\{{ cookiecutter.project_slug }}

rem Create and activate a Python venv
:install
echo Installing to %filePath%
echo Building Python virtual environment
py -3 -m venv %filePath%\env --clear
%filePath%\env\Scripts\python.exe -m pip install --upgrade pip
call %filePath%\env\Scripts\activate

rem Install the pinned dependencies from requirements.txt, then install the wheel
FOR /F "delims=" %%i IN ('dir /b %~dp0{{ cookiecutter.package_slug }}*.whl') DO set target=%~dp0%%i
FOR /F "delims=" %%i IN ('dir /b %~dp0requirements.txt') DO set requirements=%~dp0%%i
set pinFail=0
pip install -r %requirements% || set pinFail=1
pip install %target%

rem Create links to the binary for convenience, one at top level and one in a bin directory
mklink /H %filePath%\{{ cookiecutter.project_slug }}.exe %filePath%\env\Scripts\{{ cookiecutter.project_slug }}.exe
mklink /H %filePath%\bin\{{ cookiecutter.project_slug }}.exe %filePath%\env\Scripts\{{ cookiecutter.project_slug }}.exe

rem Copy files from installer directory to their target locations
rem Alias robocopy with switches that prevent any overwriting and suppress output
set "rcopy=robocopy /S /E /XC /XN /XO /NFL /NDL /NJH /NJS /nc /ns /np"
{% if cookiecutter.config_file_type != "none" %}
rcopy %~dp0 %filePath% config.{{ cookiecutter.config_file_type }}
{% endif %}
xcopy %~dp0readme_for_app.md %filePath%\readme.md /Q
rcopy %~dp0resources %filePath%\
rcopy %~dp0data %filePath%\

rem Record details of installation method in a Python module accessible at run-time
echo install_method, install_target = "one_dir","%filePath%" > %filePath%\env\Lib\site-packages\{{ cookiecutter.package_slug }}\_options.py

echo *************************
echo Installation complete
if %pinFail%==1 echo WARNING: pinned versions of dependencies could not be installed. Instead dependency resolution was performed by pip, it will probably work but is not exactly as tested.
echo Consider adding %filePath%/bin to your PATH for quick access to {{ cookiecutter.project_name }}
echo *************************