@echo off
echo *************************
echo Installing {{ cookiecutter.project_name }}
echo *************************
IF %1.==. set filePath=C:\{{ cookiecutter.project_slug }}& GOTO install
set filePath=%1\{{ cookiecutter.project_slug }}
:install
echo Installing to %filePath%
echo Building Python virtual environment
py -3 -m venv %filePath%\env
FOR /F "delims=" %%i IN ('dir /b %~dp0{{ cookiecutter.package_slug }}*.whl') DO set target=%~dp0%%i
FOR /F "delims=" %%i IN ('dir /b %~dp0requirements.txt') DO set requirements=%~dp0%%i
%filePath%\env\Scripts\python.exe -m pip install --upgrade pip
call %filePath%\env\Scripts\activate
set pinFail=0
pip install -r %requirements% || set pinFail=1
pip install %target%
mklink /H %filePath%\{{ cookiecutter.project_slug }}.exe %filePath%\env\Scripts\{{ cookiecutter.project_slug }}.exe
xcopy %~dp0config.{{ cookiecutter.config_file_type }} %filePath%\ /F/Q
xcopy %~dp0readme_for_app.md %filePath%\readme.md /F/Q
xcopy %~dp0resources %filePath%\ /F/Q/S/E
xcopy %~dp0data %filePath%\ /F/Q/S/E
rem FOR /F "delims=" %%i IN (%filePath%\env\Lib\site-packages\{{ cookiecutter.package_slug }}\_options.py) DO set options=%%i
echo install_method, install_target = "one_dir","%filePath%" > %filePath%\env\Lib\site-packages\{{ cookiecutter.package_slug }}\_options.py
echo *************************
echo Installation complete
if %pinFail%==1 echo WARNING: pinned versions of dependencies could not be installed. Instead dependency resolution was performed by pip, it will probably work but is not exactly as tested.
echo *************************