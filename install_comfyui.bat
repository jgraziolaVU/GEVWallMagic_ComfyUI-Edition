@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
:: PARALLAX STUDIO - COMFYUI EDITION INSTALLER
:: Version 1.2
:: ============================================================================

title Parallax Studio - ComfyUI Installer

cls
echo.
echo  ======================================================
echo.
echo     ◈  PARALLAX STUDIO - COMFYUI EDITION  ◈
echo                   INSTALLER v1.2
echo.
echo  ======================================================
echo.
echo  This will install:
echo.
echo    • ComfyUI (if not already installed)
echo    • Parallax Studio custom nodes
echo    • Apple SHARP model
echo    • Qwen-Image-Edit dependencies
echo    • FFmpeg for video encoding
echo.
echo  Requirements:
echo    • NVIDIA GPU with 24GB+ VRAM (RTX 4090/5090)
echo    • 50GB free disk space
echo    • Internet connection
echo.
echo  ======================================================
echo.

pause
cls

:: ============================================================================
:: Configuration
:: ============================================================================

set "INSTALL_DIR=%USERPROFILE%\ParallaxStudio"
set "COMFYUI_DIR=%INSTALL_DIR%\ComfyUI"
set "NODES_DIR=%COMFYUI_DIR%\custom_nodes\parallax_studio"

:: ============================================================================
:: STEP 1: Check for NVIDIA GPU
:: ============================================================================

echo.
echo  [Step 1/8] Checking for NVIDIA GPU...
echo.

nvidia-smi >nul 2>&1
if %errorLevel% neq 0 (
    echo  [ERROR] NVIDIA GPU not detected!
    echo  Parallax Studio requires an RTX 4090/5090 or similar.
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('nvidia-smi --query-gpu=name,memory.total --format=csv,noheader') do (
    echo  [OK] Found: %%i
)
echo.

:: ============================================================================
:: STEP 2: Check/Install Git
:: ============================================================================

echo.
echo  [Step 2/8] Checking for Git...
echo.

where git >nul 2>&1
if %errorLevel% neq 0 (
    echo  [ERROR] Git is not installed.
    echo  Please download from: https://git-scm.com/download/win
    echo  After installing, restart this installer.
    echo.
    pause
    exit /b 1
)

echo  [OK] Git is installed
echo.

:: ============================================================================
:: STEP 3: Check/Install Python
:: ============================================================================

echo.
echo  [Step 3/8] Checking for Python...
echo.

where python >nul 2>&1
if %errorLevel% neq 0 (
    echo  Python not found. Installing via winget...
    winget install Python.Python.3.11
    
    if %errorLevel% neq 0 (
        echo  [ERROR] Failed to install Python.
        echo  Please install Python 3.11 manually from python.org
        pause
        exit /b 1
    )
    
    echo  [!] Python installed. Please RESTART this installer.
    pause
    exit /b 0
)

python --version
echo  [OK] Python is installed
echo.

:: ============================================================================
:: STEP 4: Create Installation Directory
:: ============================================================================

echo.
echo  [Step 4/8] Setting up installation directory...
echo.

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
cd /d "%INSTALL_DIR%"

echo  [OK] Installation directory: %INSTALL_DIR%
echo.

:: ============================================================================
:: STEP 5: Clone/Update ComfyUI
:: ============================================================================

echo.
echo  [Step 5/8] Installing ComfyUI...
echo.

if not exist "%COMFYUI_DIR%" (
    echo  Cloning ComfyUI repository...
    git clone https://github.com/comfyanonymous/ComfyUI.git
    
    if %errorLevel% neq 0 (
        echo  [ERROR] Failed to clone ComfyUI.
        pause
        exit /b 1
    )
) else (
    echo  ComfyUI exists, updating...
    cd ComfyUI
    git pull
    cd ..
)

echo  [OK] ComfyUI ready
echo.

:: ============================================================================
:: STEP 6: Install Python Dependencies
:: ============================================================================

echo.
echo  [Step 6/8] Installing Python dependencies...
echo  (This may take 10-20 minutes)
echo.

cd "%COMFYUI_DIR%"

:: Install ComfyUI requirements
echo  Installing ComfyUI requirements...
pip install -r requirements.txt

:: Install PyTorch with CUDA (if not already installed)
echo  Installing PyTorch with CUDA 12.1...
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

:: Install Qwen-Image-Edit dependencies
echo  Installing Qwen-Image-Edit (diffusers)...
pip install git+https://github.com/huggingface/diffusers

:: Install SHARP dependencies
echo  Installing SHARP dependencies...
pip install huggingface-hub plyfile gsplat tqdm

:: Install FFmpeg via pip (as backup)
pip install imageio-ffmpeg

echo.
echo  [OK] Python dependencies installed
echo.

:: ============================================================================
:: STEP 7: Install Parallax Studio Custom Nodes
:: ============================================================================

echo.
echo  [Step 7/8] Installing Parallax Studio nodes...
echo.

:: Create custom nodes directory
if not exist "%NODES_DIR%" mkdir "%NODES_DIR%"

:: Copy node files (assuming they're in same folder as installer)
set "SCRIPT_DIR=%~dp0"

if exist "%SCRIPT_DIR%__init__.py" (
    copy "%SCRIPT_DIR%__init__.py" "%NODES_DIR%\" >nul
    copy "%SCRIPT_DIR%qwen_nodes.py" "%NODES_DIR%\" >nul
    copy "%SCRIPT_DIR%sharp_nodes.py" "%NODES_DIR%\" >nul
    copy "%SCRIPT_DIR%video_nodes.py" "%NODES_DIR%\" >nul
    echo  [OK] Node files copied
) else (
    echo  [!] Node files not found in installer directory.
    echo      Please manually copy the following to:
    echo      %NODES_DIR%
    echo.
    echo      - __init__.py
    echo      - qwen_nodes.py
    echo      - sharp_nodes.py
    echo      - video_nodes.py
)

:: Copy workflow file
if exist "%SCRIPT_DIR%parallax_workflow.json" (
    if not exist "%COMFYUI_DIR%\user\default\workflows" mkdir "%COMFYUI_DIR%\user\default\workflows"
    copy "%SCRIPT_DIR%parallax_workflow.json" "%COMFYUI_DIR%\user\default\workflows\" >nul
    echo  [OK] Workflow template copied
)

:: Create model directories
if not exist "%COMFYUI_DIR%\models\sharp" mkdir "%COMFYUI_DIR%\models\sharp"

echo.
echo  [OK] Custom nodes installed
echo.

:: ============================================================================
:: STEP 8: Download SHARP Model
:: ============================================================================

echo.
echo  [Step 8/8] Downloading SHARP model checkpoint...
echo  (This is approximately 500MB)
echo.

python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='apple/Sharp', filename='sharp_2572gikvuh.pt', local_dir='%COMFYUI_DIR%\models\sharp')"

if %errorLevel% neq 0 (
    echo  [WARNING] Model download failed. Will download on first use.
) else (
    echo  [OK] SHARP model downloaded
)

echo.

:: ============================================================================
:: Create Launcher Script
:: ============================================================================

echo.
echo  Creating launcher...
echo.

(
echo @echo off
echo title Parallax Studio - ComfyUI
echo cd /d "%COMFYUI_DIR%"
echo echo.
echo echo  ======================================================
echo echo.
echo echo     ◈  PARALLAX STUDIO - COMFYUI EDITION  ◈
echo echo.
echo echo  ======================================================
echo echo.
echo echo  Starting ComfyUI server...
echo echo  Web interface will open at: http://127.0.0.1:8188
echo echo.
echo echo  To stop: Close this window or press Ctrl+C
echo echo.
echo echo  ======================================================
echo echo.
echo python main.py --listen --highvram
echo pause
) > "%INSTALL_DIR%\run_parallax_studio.bat"

:: Create desktop shortcut
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\Parallax Studio (ComfyUI).lnk'); $s.TargetPath = '%INSTALL_DIR%\run_parallax_studio.bat'; $s.WorkingDirectory = '%COMFYUI_DIR%'; $s.IconLocation = 'shell32.dll,13'; $s.Save()"

echo  [OK] Launcher created on Desktop
echo.

:: ============================================================================
:: Installation Complete
:: ============================================================================

cls
echo.
echo  ======================================================
echo.
echo     ◈  INSTALLATION COMPLETE!  ◈
echo.
echo  ======================================================
echo.
echo  Parallax Studio has been installed to:
echo  %INSTALL_DIR%
echo.
echo  To run:
echo    • Double-click "Parallax Studio (ComfyUI)" on Desktop
echo    • Or run: %INSTALL_DIR%\run_parallax_studio.bat
echo.
echo  First launch will:
echo    • Start ComfyUI at http://127.0.0.1:8188
echo    • Download Qwen model (~40GB) on first use
echo.
echo  Workflow location:
echo    ComfyUI ^> Load ^> parallax_workflow.json
echo.
echo  ======================================================
echo.

set /p LAUNCH="  Launch Parallax Studio now? (y/n): "
if /i "%LAUNCH%"=="y" (
    echo.
    echo  Starting Parallax Studio...
    start "" "%INSTALL_DIR%\run_parallax_studio.bat"
)

echo.
pause
exit /b 0
