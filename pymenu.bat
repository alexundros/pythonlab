::================================================
:: PythonLab utils menu, alxpro.ru               =
:: Version v202306300000                         =
:: SHA1 60FB94B4EE2348FBF18840C6AAECCD64469FE934 =
::================================================
@echo off
@chcp 1251 > nul
cd /d "%~dp0" & title %0
if not "%1"=="" call :%* & exit /b
if "%1"=="" (
    @setlocal enabledelayedexpansion
    set _PATH=%PATH%;
    goto :menu
)

:clean
    set cls=n
    set /p cls="# Clear the output (!cls!)?> "
    if "%cls%"=="y" (cls) else echo.
exit /b
:pypath
    call :_setpython
    setx PYTHON_PATH %pp%
exit /b
:python
    call :_setpython
    set opt=%*
    if "%opt%"=="" set /p opt="# python> "
    if "%opt%"=="" goto :python
    %pp%/python %opt%
exit /b
:script
    call :_setpython
    call :_setscript
    call :_install "%sd%requirements.txt"
    if not %errorlevel% == 0 exit /b
    cd %sd%
    set (arg=) & set /p arg="# %ps% "
    cmd /c %pp%/python %~dp0%ps% %arg%
    cd %~dp0
exit /b
:jupyterlab
    call :_setpython
    cd %~dp0jupyterlab
    call :_install "%cd%/requirements.txt"
    set cmd=%pp%/python -m jupyterlab
    start cmd /c %cmd% ^& pause
    cd %~dp0
exit /b
:_setpython
    set "si=?" & set /a c=0
    echo # Select python path:
    for /d %%a in ("*") do (
      if exist "%%a/python.exe" (
        set /a c+=1
        set n!c!=%~dp0%%a
        echo # !c! - %%a
      )
    )
    set /p si="# item> "
    set "pp=!n%si%!"
    if "%pp%"=="" goto :_setpython
    set PYTHON_PATH=%pp%
    set PATH=%pp%;%pp%\Scripts;%_PATH%
exit /b
:_setscript
    set "si=?" & set /a c=0
    echo # Select python file:
    set cmd=dir /s /b scripts\*.py
    for /f %%a in ('%cmd%') do (
        set /a c+=1
        set dn=%%~dpa
        set dn=!dn:%~dp0=!
        set fn=%%a
        set fn=!fn:%~dp0=!
        set d!c!=!dn!
        set n!c!=!fn!
        echo # !c! - !fn!
    )
    set /p si="# item> "
    set "sd=!d%si%!"
    set "ps=!n%si%!"
    if "%ps%"=="" goto :_setscript
exit /b
:_pyversion
    set cmd=%pp%/python -V
    for /f "tokens=1,2" %%a in ('%cmd%') do (
      set pyver=%%a_%%b
      exit /b
    )
exit /b
:_install
    if not exist "%~1" exit /b
    call :_pyversion
    set lock=%~1.pylab
    if exist "%lock%" (
      for /f "tokens=1,2,3" %%a in (%lock%) do (
        if "%%a"=="!pyver!" exit /b
      )
    )
    echo Python install requirements: %~1
    %pp%/python -m pip install -r "%~1"
    if not %errorlevel% == 0 exit /b
    set stamp=%date% %time:~0,8%
    echo !pyver! %stamp%>> "%lock%"
exit /b

:menu
    if not "%mi%"=="" echo.
    echo # PythonLab menu:
    echo # 0 - === Exit ===
    echo # 1 - Set PYTHON_PATH
    echo # 2 - Start Python
    echo # 3 - Python script
    echo # 4 - Start jupyterlab
    echo # 5 - Assoc ftype .py
    if exist "%~dp0_pymenu.bat" (
      echo # === Additional ===
      call %~dp0_pymenu.bat menu
    )
  set "mi=" & set /p mi="# Menu item> "
    if "%mi%"=="" call :clean
    if "%mi%"=="0" exit /b
    if "%mi%"=="1" call :pypath
    if "%mi%"=="2" call :python
    if "%mi%"=="3" call :script
    if "%mi%"=="4" call :jupyterlab
    if "%mi%"=="5" call %~dp0setpyassoc.bat
    if exist "%~dp0_pymenu.bat" (
      call %~dp0_pymenu.bat addons
    )
goto :menu