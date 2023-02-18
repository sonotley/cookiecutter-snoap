@echo off
echo *************************
echo Installing {{ cookiecutter.project_name }}
echo *************************
IF %1.==. set targetParentDir=C:& GOTO install
set targetParentDir=%1

rem Create and activate a Python venv
:install
set targetDir=%targetParentDir%\{{ cookiecutter.project_slug }}
set sourceDir=%~dp0
echo Installing from %sourceDir% to %targetDir%

echo Building Python virtual environment using:
py -3 -c "import sys; print(sys.executable, sys.version, sep='\n')"
py -3 -m venv %targetDir%\env --clear
%targetDir%\env\Scripts\python.exe -m pip install --upgrade pip
call %targetDir%\env\Scripts\activate.bat
echo After venv activation, py -3 is:
py -3 -c "import sys; print(sys.executable, sys.version, sep='\n')"
echo and python is:
python -c "import sys; print(sys.executable, sys.version, sep='\n')"

rem Install the pinned dependencies from requirements.txt, then install the wheel
FOR /F "delims=" %%i IN ('dir /b %sourceDir%{{ cookiecutter.package_slug }}*.whl') DO set target=%sourceDir%%%i
FOR /F "delims=" %%i IN ('dir /b %sourceDir%requirements.txt') DO set requirements=%sourceDir%%%i || echo "WARNING: no requirements file found"
set pinFail=0
python -m pip install -r %requirements% || set pinFail=1
python -m pip install %target%

rem Create links to the binary for convenience, one at top level and one in a bin directory
mklink /H %targetDir%\{{ cookiecutter.project_slug }}.exe %targetDir%\env\Scripts\{{ cookiecutter.project_slug }}.exe
if not exist %targetDir%\bin\ mkdir %targetDir%\bin
mklink /H %targetDir%\bin\{{ cookiecutter.project_slug }}.exe %targetDir%\env\Scripts\{{ cookiecutter.project_slug }}.exe

rem Copy files from installer directory to their target locations
rem Alias robocopy with switches that prevent any overwriting and suppress output
set "rcopy=robocopy /S /E /XC /XN /XO /NFL /NDL /NJH /NJS /nc /ns /np"
{% if cookiecutter.config_file_type != "none" %}
(%rcopy% %sourceDir% %targetDir% config.{{ cookiecutter.config_file_type }}) ^& IF %ERRORLEVEL% LSS 8 SET ERRORLEVEL = 0
{% endif %}
copy %sourceDir%readme_for_app.md %targetDir%\readme.md
if not exist %sourceDir%data\ mkdir %sourceDir%data
if not exist %sourceDir%resources\ mkdir %sourceDir%resources
(%rcopy% %sourceDir%resources %targetDir%\) ^& IF %ERRORLEVEL% LSS 8 SET ERRORLEVEL = 0
(%rcopy% %sourceDir%data %targetDir%\) ^& IF %ERRORLEVEL% LSS 8 SET ERRORLEVEL = 0

rem Record details of installation method in a Python module accessible at run-time
echo install_method, install_target = "one_dir","%targetDir%" > %targetDir%\env\Lib\site-packages\{{ cookiecutter.package_slug }}\_options.py

if %sourceDir% != %targetDir%\install (
if exist %targetDir%\install\ rm -r %targetDir%\install
mkdir %targetDir%\install
%rcopy% %sourceDir% %targetDir%\install
)

echo *************************
echo Installation complete
if %pinFail%==1 echo WARNING: pinned versions of dependencies could not be installed. Instead dependency resolution was performed by pip, it will probably work but is not exactly as tested.
echo Consider adding %targetDir%\bin to your PATH for quick access to {{ cookiecutter.project_name }}
echo *************************