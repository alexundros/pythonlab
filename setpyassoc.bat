::================================================
:: PythonLab Assoc ftype .py, alxpro.ru          =
:: Version v202306300000                         =
:: SHA1 F7333894C84DAF81D9122E43BA8B2E0265C55F0D =
::================================================
@echo off
@setlocal enabledelayedexpansion
whoami /priv | find /i "SeRemoteShutdownPrivilege">nul
if %errorlevel% == 0 goto admin
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0","","","runas",1)&Close()"
exit /b
:admin
call %~dp0pymenu.bat _setpython
assoc .py=PythonLab_Python
ftype PythonLab_Python=%pp%/python.exe "%%1"
pause