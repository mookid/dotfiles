@echo off

rem nvim
rem =======================================
set nvimhome=%localappdata%\nvim
md %nvimhome% >nul 2>&1
copy %~dp0init.vim %nvimhome%\init.vim
rem =======================================

rem vim
rem =======================================
copy %~dp0init.vim %home%\_vimrc
rem =======================================
