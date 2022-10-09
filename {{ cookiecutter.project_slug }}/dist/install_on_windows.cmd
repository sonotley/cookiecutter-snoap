@echo off
echo *************************
echo Installing Example Project
echo *************************
IF %1.==. set filePath=C:\example-project& GOTO install
set filePath=%1\example-project
:install
echo Installing to %filePath%
echo Building Python virtual environment
py -3 -m venv %filePath%\env
FOR /F "delims=" %%i IN ('dir /b %~dp0example_package*.whl') DO set target=%~dp0%%i
FOR /F "delims=" %%i IN ('dir /b %~dp0requirements.txt') DO set requirements=%~dp0%%i
call %filePath%\env\Scripts\activate
pip install -r %requirements% ||
pip install %target%
mklink /H %filePath%\my-executable.exe %filePath%\env\Scripts\my-executable.exe
xcopy %~dp0setup.yaml %filePath%\ /F/Q
echo *************************
echo Installation complete
echo *************************