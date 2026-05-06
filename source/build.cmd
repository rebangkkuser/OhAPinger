@echo off
setlocal enabledelayedexpansion

set "START_TIME=%time%"

for /f "delims=" %%i in ('wmic os get localdatetime ^| find "."') do set DT=%%i

set "ARCH=%PROCESSOR_ARCHITECTURE%"
set "OUT=OhAPinger-1.0-%ARCH%-UNOFFICIAL-Compiled.exe"

where clang++ >nul 2>nul
if %errorlevel%==0 (
    set "COMPILER=clang++"
) else (
    where g++ >nul 2>nul
    if %errorlevel%==0 (
        set "COMPILER=g++"
    ) else (
        echo [OhAPinger] Error: no compiler available (clang++ or g++)
        exit /b 1
    )
)

%COMPILER% ohapinger-latest.cpp -O2 -std=c++17 -o "%OUT%"

echo [OhAPinger] Build completed: %OUT%

set "END_TIME=%time%"

for /f "tokens=1-4 delims=:.," %%a in ("%START_TIME%") do (
    set /a START_SEC=%%a*3600 + %%b*60 + %%c
)

for /f "tokens=1-4 delims=:.," %%a in ("%END_TIME%") do (
    set /a END_SEC=%%a*3600 + %%b*60 + %%c
)

set /a ELAPSED=END_SEC-START_SEC

echo [OhAPinger] Build finished on %ELAPSED%s.

endlocal
