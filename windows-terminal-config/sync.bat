@echo off

set wtDir=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState

echo copying profiles.json...
copy %~dp0\profiles.json "%wtDir%\settings.json"

echo copying bg01.jpg...
copy %~dp0\bg01.jpg %wtDir%