@echo off

echo copying profiles.json...
copy %~dp0\profiles.json "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

echo copying bg01.jpg...
copy %~dp0\bg01.jpg "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"