@echo off
REM Quick start script for Windows
REM Double-click this file or run: start.bat

echo 🚀 Starting Enhanced Cutting Diagram Tool...

REM Try Python 3 first
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo 📍 Using Python 3
    python start.py
    goto :end
)

REM Try Python command
python3 --version >nul 2>&1
if %errorlevel% == 0 (
    echo 📍 Using Python 3
    python3 start.py
    goto :end
)

REM Fallback to opening file directly
echo ⚠️  Python not found. Opening file directly in browser...
echo 💡 For best results, install Python and run this script again.
start "115 fixed .html"

:end
pause