@echo off
title ◈ Parallax Studio v1.2 - ComfyUI
call conda activate parallax_comfyui
cd /d "C:\Users\jgraziol\ParallaxStudio-ComfyUI\ComfyUI"
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
echo  Custom Nodes: GEVWallMagic_ComfyUI-Edition-main\custom_nodes
echo  Workflows: GEVWallMagic_ComfyUI-Edition-main\workflows
echo.
echo  Starting ComfyUI server...
echo.
echo  Open in browser: http://127.0.0.1:8188
echo.
echo  To stop: Close this window or press Ctrl+C
echo.
python main.py --listen --highvram
pause
```

## Now Copy Your Custom Nodes to ComfyUI

You need to copy your prepared custom nodes to where ComfyUI can find them:

**From:**
```
C:\Users\jgraziol\Documents\AI_Projects\GEV\VideoWall\GEVWallMagic_ComfyUI-Edition-main\custom_nodes\parallax_studio\
```

**To:**
```
C:\Users\jgraziol\ParallaxStudio-ComfyUI\ComfyUI\custom_nodes\parallax_studio\
```

**Copy these files:**
- `__init__.py`
- `qwen_nodes.py`
- `sharp_nodes.py`
- `video_nodes.py`

## And Copy Your Workflow

**From:**
```
C:\Users\jgraziol\Documents\AI_Projects\GEV\VideoWall\GEVWallMagic_ComfyUI-Edition-main\workflows\parallax_workflow.json
```

**To:**
```
C:\Users\jgraziol\ParallaxStudio-ComfyUI\ComfyUI\user\default\workflows\