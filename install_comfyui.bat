@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
::
::   ◈ PARALLAX STUDIO v1.2 - COMFYUI EDITION
::   Your Photos. Alive.
::
::   INSTALLER
::
:: ============================================================================

title Parallax Studio - ComfyUI Installer

cls
echo.
echo  ╔════════════════════════════════════════════════════════════╗
echo  ║                                                            ║
echo  ║     ◈  PARALLAX STUDIO v1.2 - COMFYUI EDITION  ◈          ║
echo  ║                                                            ║
echo  ║                 Your Photos. Alive.                        ║
echo  ║                                                            ║
echo  ╚════════════════════════════════════════════════════════════╝
echo.
echo  This installer will set up:
echo.
echo    [1] ComfyUI (node-based interface)
echo    [2] Parallax Studio custom nodes
echo    [3] PyTorch with CUDA
echo    [4] Apple SHARP model
echo    [5] Qwen-Image-Edit dependencies
echo    [6] FFmpeg for video encoding
echo.
echo  ────────────────────────────────────────────────────────────
echo   Requirements:
echo     • NVIDIA GPU with 24GB+ VRAM (RTX 4090/5090)
echo     • 64GB+ system RAM recommended
echo     • 60GB free disk space
echo     • Internet connection
echo  ────────────────────────────────────────────────────────────
echo.
echo  Estimated time: 20-40 minutes
echo.

pause
cls

:: ============================================================================
:: Configuration
:: ============================================================================

set "INSTALL_DIR=%USERPROFILE%\ParallaxStudio-ComfyUI"
set "COMFYUI_DIR=%INSTALL_DIR%\ComfyUI"
set "NODES_DIR=%COMFYUI_DIR%\custom_nodes\parallax_studio"
set "SCRIPT_DIR=%~dp0"

:: ============================================================================
:: STEP 1: Check GPU
:: ============================================================================

echo.
echo  [Step 1/8] Checking for NVIDIA GPU...
echo.

nvidia-smi >nul 2>&1
if %errorLevel% neq 0 (
    echo  ╔════════════════════════════════════════════════════════════╗
    echo  ║  ERROR: NVIDIA GPU not detected!                           ║
    echo  ║                                                            ║
    echo  ║  Parallax Studio requires an RTX 4090/5090 or similar.     ║
    echo  ╚════════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('nvidia-smi --query-gpu=name,memory.total --format=csv,noheader') do (
    echo  ✓ Found GPU: %%i
)
echo.

:: ============================================================================
:: STEP 2: Check Git
:: ============================================================================

echo.
echo  [Step 2/8] Checking for Git...
echo.

where git >nul 2>&1
if %errorLevel% neq 0 (
    echo  Git not found. Please install from:
    echo  https://git-scm.com/download/win
    echo.
    echo  Then restart this installer.
    pause
    exit /b 1
)

echo  ✓ Git is installed
echo.

:: ============================================================================
:: STEP 3: Check Python
:: ============================================================================

echo.
echo  [Step 3/8] Checking for Python...
echo.

where python >nul 2>&1
if %errorLevel% neq 0 (
    echo  Python not found. Installing via winget...
    winget install Python.Python.3.11
    echo.
    echo  Python installed. Please RESTART this installer.
    pause
    exit /b 0
)

python --version
echo  ✓ Python is installed
echo.

:: ============================================================================
:: STEP 4: Create Directory & Clone ComfyUI
:: ============================================================================

echo.
echo  [Step 4/8] Setting up ComfyUI...
echo.

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
cd /d "%INSTALL_DIR%"

if not exist "%COMFYUI_DIR%" (
    echo  Cloning ComfyUI repository...
    git clone https://github.com/comfyanonymous/ComfyUI.git
) else (
    echo  ComfyUI exists, updating...
    cd ComfyUI
    git pull
    cd ..
)

echo  ✓ ComfyUI ready
echo.

:: ============================================================================
:: STEP 5: Install Python Dependencies
:: ============================================================================

echo.
echo  [Step 5/8] Installing Python dependencies...
echo  (This may take 10-15 minutes)
echo.

cd "%COMFYUI_DIR%"

:: ComfyUI requirements
pip install -r requirements.txt

:: PyTorch with CUDA
echo  Installing PyTorch with CUDA 12.1...
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

:: Qwen dependencies
echo  Installing Qwen-Image-Edit (diffusers)...
pip install git+https://github.com/huggingface/diffusers

:: SHARP dependencies
echo  Installing SHARP dependencies...
pip install huggingface-hub plyfile gsplat tqdm

echo.
echo  ✓ Python dependencies installed
echo.

:: ============================================================================
:: STEP 6: Install Parallax Studio Nodes
:: ============================================================================

echo.
echo  [Step 6/8] Installing Parallax Studio nodes...
echo.

if not exist "%NODES_DIR%" mkdir "%NODES_DIR%"

:: Copy node files from installer directory
if exist "%SCRIPT_DIR%custom_nodes\parallax_studio\__init__.py" (
    xcopy "%SCRIPT_DIR%custom_nodes\parallax_studio\*.*" "%NODES_DIR%\" /Y /Q
    echo  ✓ Node files installed
) else (
    echo  WARNING: Node files not found in installer directory.
    echo  Please manually copy files to:
    echo  %NODES_DIR%
)

:: Copy workflow
if not exist "%COMFYUI_DIR%\user\default\workflows" mkdir "%COMFYUI_DIR%\user\default\workflows"
if exist "%SCRIPT_DIR%workflows\parallax_workflow.json" (
    copy "%SCRIPT_DIR%workflows\parallax_workflow.json" "%COMFYUI_DIR%\user\default\workflows\" >nul
    echo  ✓ Workflow template installed
)

:: Create model directory
if not exist "%COMFYUI_DIR%\models\sharp" mkdir "%COMFYUI_DIR%\models\sharp"

echo.

:: ============================================================================
:: STEP 7: Download SHARP Model
:: ============================================================================

echo.
echo  [Step 7/8] Downloading SHARP model (~500MB)...
echo.

python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='apple/Sharp', filename='sharp_2572gikvuh.pt', local_dir='%COMFYUI_DIR%\models\sharp')"

if %errorLevel% neq 0 (
    echo  WARNING: Model download failed. Will download on first use.
) else (
    echo  ✓ SHARP model downloaded
)

echo.

:: ============================================================================
:: STEP 8: Install FFmpeg
:: ============================================================================

echo.
echo  [Step 8/8] Setting up FFmpeg...
echo.

where ffmpeg >nul 2>&1
if %errorLevel% neq 0 (
    echo  Installing FFmpeg via pip...
    pip install imageio-ffmpeg
) else (
    echo  ✓ FFmpeg already installed
)

echo.

:: ============================================================================
:: Create Launcher
:: ============================================================================

echo.
echo  Creating launcher...
echo.

(
echo @echo off
echo title ◈ Parallax Studio v1.2 - ComfyUI
echo cd /d "%COMFYUI_DIR%"
echo cls
echo echo.
echo echo  ╔════════════════════════════════════════════════════════════╗
echo echo  ║                                                            ║
echo echo  ║     ◈  PARALLAX STUDIO v1.2 - COMFYUI EDITION  ◈          ║
echo echo  ║                                                            ║
echo echo  ║                 Your Photos. Alive.                        ║
echo echo  ║                                                            ║
echo echo  ╚════════════════════════════════════════════════════════════╝
echo echo.
echo echo  Starting ComfyUI server...
echo echo.
echo echo  Open in browser: http://127.0.0.1:8188
echo echo.
echo echo  To stop: Close this window or press Ctrl+C
echo echo.
echo python main.py --listen --highvram
echo pause
) > "%INSTALL_DIR%\run_comfyui.bat"

:: Desktop shortcut
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\Parallax Studio (ComfyUI).lnk'); $s.TargetPath = '%INSTALL_DIR%\run_comfyui.bat'; $s.WorkingDirectory = '%COMFYUI_DIR%'; $s.Description = 'Your Photos. Alive.'; $s.Save()"

echo  ✓ Desktop shortcut created
echo.

:: ============================================================================
:: Complete
:: ============================================================================

cls
echo.
echo  ╔════════════════════════════════════════════════════════════╗
echo  ║                                                            ║
echo  ║            ◈  INSTALLATION COMPLETE!  ◈                    ║
echo  ║                                                            ║
echo  ╚════════════════════════════════════════════════════════════╝
echo.
echo  Parallax Studio ComfyUI Edition installed at:
echo  %INSTALL_DIR%
echo.
echo  ────────────────────────────────────────────────────────────
echo.
echo  TO RUN:
echo.
echo    • Double-click "Parallax Studio (ComfyUI)" on Desktop
echo.
echo    • Or run: %INSTALL_DIR%\run_comfyui.bat
echo.
echo  ────────────────────────────────────────────────────────────
echo.
echo  FIRST RUN:
echo.
echo    1. Open http://127.0.0.1:8188 in your browser
echo    2. Load workflow: Load → parallax_workflow.json
echo    3. Qwen model (~40GB) downloads on first use
echo.
echo  ────────────────────────────────────────────────────────────
echo.

set /p LAUNCH="  Launch Parallax Studio now? (y/n): "
if /i "%LAUNCH%"=="y" (
    start "" "%INSTALL_DIR%\run_comfyui.bat"
)

echo.
echo  Your Photos. Alive.
echo.
pause
exit /b 0
