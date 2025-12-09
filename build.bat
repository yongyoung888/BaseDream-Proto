@echo off

echo Running build_client.bat ...
call "%~dp0build_client.bat"

echo Running build_server.bat ...
call "%~dp0build_server.bat"

echo All done.
pause
