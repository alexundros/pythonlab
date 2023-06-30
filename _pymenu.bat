::================================================
:: PythonLab addons, alxpro.ru                   =
:: Version v202306300000                         =
:: SHA1 A52521D37AAE34AC3A261116E8061CD9D424FE97 =
::================================================
@echo off
@chcp 1251 > nul
call :%* & exit /b

:menu
    echo # 6 - Test command
exit /b
:addons
    if "%mi%"=="6" call :test
exit /b
:test
    echo Test started
exit /b