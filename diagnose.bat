@echo off
setlocal

:: ============================================================================
::
::   ◈ PARALLAX STUDIO - SYSTEM DIAGNOSTIC
::
::   Run this and paste the output to Claude for troubleshooting.
::
:: ============================================================================

title Parallax Studio - Diagnostic

cls
echo.
echo ============================================================
echo  PARALLAX STUDIO - SYSTEM DIAGNOSTIC
echo  Copy everything below and paste to Claude
echo ============================================================
echo.
echo --- WINDOWS VERSION ---
ver
echo.

echo --- USER PROFILE ---
echo %USERPROFILE%
echo.

echo --- NVIDIA-SMI VERSION ---
nvidia-smi --version 2>&1
echo.

echo --- NVIDIA-SMI BASIC ---
nvidia-smi 2>&1
echo.

echo --- GIT VERSION ---
where git 2>&1
git --version 2>&1
echo.

echo --- PYTHON VERSION ---
where python 2>&1
python --version 2>&1
echo.

echo --- CONDA VERSION ---
where conda 2>&1
conda --version 2>&1
echo.

echo --- PIP VERSION ---
pip --version 2>&1
echo.

echo --- POWERSHELL VERSION ---
powershell -Command "$PSVersionTable.PSVersion.ToString()" 2>&1
echo.

echo --- PATH VARIABLE ---
echo %PATH%
echo.

echo --- TEMP FOLDER ---
echo %TEMP%
dir "%TEMP%" /b 2>&1 | find /c /v "" 
echo files in temp
echo.

echo --- DISK SPACE (C:) ---
for /f "tokens=3" %%a in ('dir C:\ /-c 2^>nul ^| find "bytes free"') do echo %%a bytes free
echo.

echo ============================================================
echo  END OF DIAGNOSTIC
echo ============================================================
echo.
pause