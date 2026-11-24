@echo off
title DPG Simulator Server
cd /d "%~dp0dpg_sim_export"
echo ===================================================
echo   DPG Simulator - Local Web Server
echo ===================================================
echo.
echo Starting server at http://localhost:8080 ...
start http://localhost:8080

where python >nul 2>nul
if %ERRORLEVEL% equ 0 (
    python -m http.server 8080
    goto end
)

if exist "%LOCALAPPDATA%\Python\pythoncore-3.15-64\python.exe" (
    "%LOCALAPPDATA%\Python\pythoncore-3.15-64\python.exe" -m http.server 8080
    goto end
)

where npx >nul 2>nul
if %ERRORLEVEL% equ 0 (
    npx http-server -p 8080
    goto end
)

echo [ERROR] Neither Python nor Node.js http-server found.
pause

:end
