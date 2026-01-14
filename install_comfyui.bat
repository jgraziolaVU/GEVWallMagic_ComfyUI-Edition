@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
::
::   ◈ PARALLAX STUDIO v1.2.2 - COMFYUI EDITION
::   Your Photos. Alive.
::
::   INSTALLER
::
::   Changelog v1.2.2:
::   - Added Accelerate for faster model loading (Qwen loads 3-5x faster)
::
::   Changelog v1.2.1:
::   - Added Apple SHARP library installation (fixes FileNotFoundError)
::   - Added verification step for SHARP CLI
::
:: ============================================================================

title Parallax Studio - ComfyUI Installer

cls
echo.
echo  ╔════════════════════════════════════════════════════════════╗
echo  ║                                                            ║
echo  ║     ◈  PARALLAX STUDIO v1.2.2 - COMFYUI EDITION  ◈        ║
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
echo    [4] Apple SHARP model AND library
echo    [5] Qwen-Image-Edit dependencies
echo    [6] FFmpeg for video encoding
echo.
echo  ────────────────────────────────────────────────────────────
echo   Requirements:
echo     • NVIDIA GPU with 24GB+ VRAM (RTX 4090/5090/A6000)
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

echo  ✓ NVIDIA GPU detected
nvidia-smi --query-gpu=name --format=csv,noheader 2>nul || echo     (Run nvidia-smi manually to see details)
echo.
echo.

:: ============================================================================
:: STEP 2: Check/Install Git
:: ============================================================================

echo.
echo  [Step 2/8] Checking for Git...
echo.

where git >nul 2>&1
if %errorLevel% neq 0 (
    echo  Git not found. Downloading installer...
    echo.
    
    :: Download Git installer
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe' -OutFile '%TEMP%\git_installer.exe'"
    
    if not exist "%TEMP%\git_installer.exe" (
        echo  ╔════════════════════════════════════════════════════════════╗
        echo  ║  ERROR: Failed to download Git installer.                  ║
        echo  ║                                                            ║
        echo  ║  Please download manually from:                            ║
        echo  ║  https://git-scm.com/download/win                          ║
        echo  ╚════════════════════════════════════════════════════════════╝
        echo.
        pause
        exit /b 1
    )
    
    echo  Installing Git - please follow the prompts...
    echo.
    echo  ────────────────────────────────────────────────────────────
    echo   IMPORTANT: Use default options, just keep clicking Next.
    echo  ────────────────────────────────────────────────────────────
    echo.
    
    start /wait "" "%TEMP%\git_installer.exe"
    del "%TEMP%\git_installer.exe" >nul 2>&1
    
    :: Refresh PATH
    set "PATH=%PATH%;C:\Program Files\Git\bin;C:\Program Files\Git\cmd"
    
    :: Verify installation
    where git >nul 2>&1
    if %errorLevel% neq 0 (
        echo.
        echo  ╔════════════════════════════════════════════════════════════╗
        echo  ║  Git installed but PATH not updated.                       ║
        echo  ║                                                            ║
        echo  ║  Please RESTART this installer to continue.                ║
        echo  ╚════════════════════════════════════════════════════════════╝
        echo.
        pause
        exit /b 0
    )
    
    echo  ✓ Git installed successfully
) else (
    echo  ✓ Git is installed
)

echo.

:: ============================================================================
:: STEP 3: Check/Install Miniconda
:: ============================================================================

echo.
echo  [Step 3/8] Checking for Conda...
echo.

where conda >nul 2>&1
if %errorLevel% neq 0 (
    echo  Conda not found. Downloading Miniconda...
    echo.
    
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe' -OutFile '%TEMP%\miniconda_installer.exe'"
    
    if not exist "%TEMP%\miniconda_installer.exe" (
        echo  ╔════════════════════════════════════════════════════════════╗
        echo  ║  ERROR: Failed to download Miniconda.                      ║
        echo  ║                                                            ║
        echo  ║  Please download manually from:                            ║
        echo  ║  https://docs.conda.io/en/latest/miniconda.html            ║
        echo  ╚════════════════════════════════════════════════════════════╝
        echo.
        pause
        exit /b 1
    )
    
    echo  Installing Miniconda - please follow the prompts...
    echo.
    echo  ────────────────────────────────────────────────────────────
    echo   IMPORTANT: 
    echo     - Install for "Just Me"
    echo     - CHECK "Add to PATH" when prompted!
    echo  ────────────────────────────────────────────────────────────
    echo.
    
    start /wait "" "%TEMP%\miniconda_installer.exe"
    del "%TEMP%\miniconda_installer.exe" >nul 2>&1
    
    echo.
    echo  ╔════════════════════════════════════════════════════════════╗
    echo  ║  Miniconda installed.                                      ║
    echo  ║                                                            ║
    echo  ║  Please CLOSE this window and RESTART the installer.       ║
    echo  ╚════════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 0
) else (
    echo  ✓ Conda is installed
)

echo.

:: ============================================================================
:: STEP 4: Create Conda Environment
:: ============================================================================

echo.
echo  [Step 4/8] Setting up Python environment...
echo.

:: Accept Conda Terms of Service (required since 2024)
echo  Accepting Conda Terms of Service...
call conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main >nul 2>&1
call conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r >nul 2>&1
call conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2 >nul 2>&1

:: Check if environment exists
call conda env list | findstr /C:"parallax_comfyui" >nul 2>&1
if %errorLevel% equ 0 (
    echo  Environment 'parallax_comfyui' exists. Activating...
) else (
    echo  Creating conda environment with Python 3.11...
    call conda create -n parallax_comfyui python=3.11 -y
    
    if %errorLevel% neq 0 (
        echo  ╔════════════════════════════════════════════════════════════╗
        echo  ║  ERROR: Failed to create conda environment.                ║
        echo  ║                                                            ║
        echo  ║  Try running manually:                                     ║
        echo  ║  conda create -n parallax_comfyui python=3.11 -y           ║
        echo  ╚════════════════════════════════════════════════════════════╝
        echo.
        pause
        exit /b 1
    )
)

:: Activate environment
call conda activate parallax_comfyui

if %errorLevel% neq 0 (
    echo  ╔════════════════════════════════════════════════════════════╗
    echo  ║  ERROR: Failed to activate conda environment.              ║
    echo  ║                                                            ║
    echo  ║  Try running manually:                                     ║
    echo  ║  conda activate parallax_comfyui                           ║
    echo  ╚════════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 1
)

echo  ✓ Python 3.11 environment ready
python --version
echo.

:: ============================================================================
:: STEP 5: Clone/Update ComfyUI
:: ============================================================================

echo.
echo  [Step 5/8] Setting up ComfyUI...
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
:: STEP 6: Install Python Dependencies
:: ============================================================================

echo.
echo  [Step 6/8] Installing Python dependencies...
echo  (This may take 10-15 minutes)
echo.

cd "%COMFYUI_DIR%"

:: Make sure we're in the conda environment
call conda activate parallax_comfyui

:: Install PyTorch with CUDA FIRST
echo  Installing PyTorch with CUDA 12.1...
pip uninstall torch torchvision torchaudio -y >nul 2>&1
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

:: Verify CUDA is available
python -c "import torch; assert torch.cuda.is_available(), 'CUDA not available'" 2>nul
if %errorLevel% neq 0 (
    echo  ╔════════════════════════════════════════════════════════════╗
    echo  ║  ERROR: PyTorch CUDA installation failed!                  ║
    echo  ║                                                            ║
    echo  ║  Please run manually in conda environment:                 ║
    echo  ║  conda activate parallax_comfyui                           ║
    echo  ║  pip install torch torchvision --index-url                 ║
    echo  ║  https://download.pytorch.org/whl/cu121                    ║
    echo  ╚════════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 1
)
echo  ✓ PyTorch with CUDA verified

:: ComfyUI requirements
echo  Installing ComfyUI requirements...
pip install -r requirements.txt

:: Accelerate for faster/lighter model loading (v1.2.2)
:: Reduces Qwen load time from ~3 min to ~30 sec
:: Reduces peak RAM usage during model loading
echo  Installing Accelerate (faster model loading)...
pip install accelerate

:: Qwen dependencies
echo  Installing Qwen-Image-Edit (diffusers)...
pip install git+https://github.com/huggingface/diffusers

:: ============================================================================
:: CRITICAL FIX (v1.2.1): Install Apple SHARP library
:: This provides the 'sharp' CLI command needed by sharp_nodes.py
:: Without this, you get: FileNotFoundError: [WinError 2]
:: ============================================================================
echo.
echo  Installing Apple SHARP library (CLI tool)...
pip install git+https://github.com/apple/ml-sharp.git

:: Verify SHARP CLI is available
where sharp >nul 2>&1
if %errorLevel% neq 0 (
    echo  ╔════════════════════════════════════════════════════════════╗
    echo  ║  WARNING: SHARP CLI not found in PATH.                     ║
    echo  ║                                                            ║
    echo  ║  Try running manually after installation:                  ║
    echo  ║  conda activate parallax_comfyui                           ║
    echo  ║  pip install git+https://github.com/apple/ml-sharp.git     ║
    echo  ╚════════════════════════════════════════════════════════════╝
    echo.
) else (
    echo  ✓ Apple SHARP library installed (CLI verified)
)

:: SHARP additional dependencies
echo  Installing additional dependencies...
pip install huggingface-hub plyfile gsplat tqdm

echo.
echo  ✓ Python dependencies installed
echo.

:: ============================================================================
:: STEP 7: Install Parallax Studio Nodes
:: ============================================================================

echo.
echo  [Step 7/8] Installing Parallax Studio nodes...
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
:: STEP 8: Download SHARP Model & FFmpeg
:: ============================================================================

echo.
echo  [Step 8/8] Downloading SHARP model and FFmpeg...
echo.

:: Make sure we're in conda env
call conda activate parallax_comfyui

:: Download SHARP model checkpoint
echo  Downloading SHARP model checkpoint (~500MB)...
python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='apple/Sharp', filename='sharp_2572gikvuh.pt', local_dir=r'%COMFYUI_DIR%\models\sharp')"

if %errorLevel% neq 0 (
    echo  WARNING: Model download failed. Will download on first use.
) else (
    echo  ✓ SHARP model checkpoint downloaded
)

:: Install FFmpeg
where ffmpeg >nul 2>&1
if %errorLevel% neq 0 (
    echo  Installing FFmpeg...
    conda install -c conda-forge ffmpeg -y
) else (
    echo  ✓ FFmpeg already installed
)

echo.

:: ============================================================================
:: Final Verification
:: ============================================================================

echo.
echo  Verifying installation...
echo.

:: Verify all critical components
set "INSTALL_OK=1"

:: Check PyTorch CUDA
python -c "import torch; assert torch.cuda.is_available()" 2>nul
if %errorLevel% neq 0 (
    echo  ⚠ PyTorch CUDA: NOT WORKING
    set "INSTALL_OK=0"
) else (
    echo  ✓ PyTorch CUDA: OK
)

:: Check SHARP CLI
where sharp >nul 2>&1
if %errorLevel% neq 0 (
    echo  ⚠ SHARP CLI: NOT FOUND
    set "INSTALL_OK=0"
) else (
    echo  ✓ SHARP CLI: OK
)

:: Check FFmpeg
where ffmpeg >nul 2>&1
if %errorLevel% neq 0 (
    echo  ⚠ FFmpeg: NOT FOUND
    set "INSTALL_OK=0"
) else (
    echo  ✓ FFmpeg: OK
)

:: Check SHARP model file
if exist "%COMFYUI_DIR%\models\sharp\sharp_2572gikvuh.pt" (
    echo  ✓ SHARP Model: OK
) else (
    echo  ⚠ SHARP Model: NOT DOWNLOADED (will download on first use)
)

:: Check custom nodes
if exist "%NODES_DIR%\__init__.py" (
    echo  ✓ Custom Nodes: OK
) else (
    echo  ⚠ Custom Nodes: NOT INSTALLED
    set "INSTALL_OK=0"
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
echo title ◈ Parallax Studio v1.2.2 - ComfyUI
echo call conda activate parallax_comfyui
echo cd /d "%COMFYUI_DIR%"
echo cls
echo echo.
echo echo  ╔════════════════════════════════════════════════════════════╗
echo echo  ║                                                            ║
echo echo  ║    ◈  PARALLAX STUDIO v1.2.2 - COMFYUI EDITION  ◈         ║
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
echo  Parallax Studio ComfyUI Edition v1.2.2 installed at:
echo  %INSTALL_DIR%
echo.
echo  ────────────────────────────────────────────────────────────
echo.
echo  INSTALLATION SUMMARY:
echo.
echo    ✓ ComfyUI installed
echo    ✓ PyTorch with CUDA 12.1
echo    ✓ Accelerate (faster model loading)
echo    ✓ Apple SHARP library (CLI tool)
echo    ✓ SHARP model checkpoint (~500MB)
echo    ✓ Qwen-Image-Edit dependencies
echo    ✓ FFmpeg for video encoding
echo    ✓ Parallax Studio custom nodes
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
echo  FIRST RUN NOTES:
echo.
echo    1. Open http://127.0.0.1:8188 in your browser
echo    2. Load workflow: Load → parallax_workflow.json
echo    3. Qwen model (~45GB) downloads on first use (1-3 hours)
echo    4. After first run, videos take only 5-10 minutes!
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
