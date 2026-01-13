# ◈ Parallax Studio - ComfyUI Edition

**Version 1.2** | Chain Qwen-Image-Edit + Apple SHARP for depth-enhanced video wall content

---

## What's Included

```
parallax_studio/
├── __init__.py              # Node registration
├── qwen_nodes.py            # Qwen-Image-Edit nodes
├── sharp_nodes.py           # Apple SHARP 3D extraction nodes
├── video_nodes.py           # Video encoding nodes
├── parallax_workflow.json   # Pre-built workflow
├── install_comfyui.bat      # One-click installer
└── README.md                # This file
```

---

## Quick Start

### Option 1: Automatic Installation (Recommended)

1. Double-click `install_comfyui.bat`
2. Wait 15-30 minutes for installation
3. Double-click "Parallax Studio (ComfyUI)" shortcut on Desktop
4. Open http://127.0.0.1:8188 in your browser
5. Load the workflow: **Load → parallax_workflow.json**

### Option 2: Manual Installation

```bash
# 1. Clone ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI

# 2. Install requirements
pip install -r requirements.txt
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

# 3. Install additional dependencies
pip install git+https://github.com/huggingface/diffusers
pip install huggingface-hub plyfile gsplat tqdm

# 4. Copy Parallax Studio nodes
mkdir -p custom_nodes/parallax_studio
# Copy all .py files to this folder

# 5. Download SHARP model
mkdir -p models/sharp
huggingface-cli download --include sharp_2572gikvuh.pt --local-dir models/sharp apple/Sharp

# 6. Run ComfyUI
python main.py --listen --highvram
```

---

## The Workflow

```
┌─────────────┐     ┌─────────────────┐     ┌───────────────┐
│ Load Image  │────▶│ Qwen-Image-Edit │────▶│ Bypass Switch │
└─────────────┘     │ (Style Transfer)│     │ (ON/OFF)      │
                    └─────────────────┘     └───────┬───────┘
                                                    │
                    ┌───────────────────────────────▼───────┐
                    │         Crop to Aspect Ratio          │
                    │    (16:9, 21:9, 32:9, or custom)      │
                    └───────────────────────────────┬───────┘
                                                    │
┌─────────────────┐                                 │
│ SHARP Model     │─────────┐                       │
│ Loader          │         │                       │
└─────────────────┘         ▼                       │
                    ┌───────────────┐               │
                    │ SHARP Predict │◀──────────────┘
                    │ (3D Extract)  │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐     ┌────────────────┐
                    │   Gaussian    │◀────│ Camera Path    │
                    │ Splat Render  │     │ Generator      │
                    └───────┬───────┘     └────────────────┘
                            │
                            ▼
                    ┌───────────────┐     ┌────────────────┐
                    │ Video Encode  │────▶│  Save Video    │
                    │ (FFmpeg)      │     │  (.mp4)        │
                    └───────────────┘     └────────────────┘
```

---

## Custom Nodes Reference

### Qwen Nodes (Parallax Studio/Qwen)

| Node | Description |
|------|-------------|
| **Qwen-Image-Edit Loader** | Load the 20B Qwen model (downloads ~40GB on first use) |
| **Qwen Image Edit** | Apply style transfer with presets or custom prompts |
| **Qwen Image Edit (Batch)** | Process multiple images |

**Style Presets:**
- Studio Ghibli
- Oil Painting
- Watercolor
- Cyberpunk
- Golden Hour
- Noir
- Impressionist
- Pixel Art
- Vintage Film
- Dramatic Sky
- Add Fog
- Winter Scene

### SHARP Nodes (Parallax Studio/SHARP)

| Node | Description |
|------|-------------|
| **SHARP Model Loader** | Load Apple SHARP checkpoint |
| **SHARP Predict** | Extract 3D Gaussian Splat from image |
| **Save Gaussian Splat** | Export .ply file for external use |

### Render Nodes (Parallax Studio/Render)

| Node | Description |
|------|-------------|
| **Parallax Camera Path** | Generate oscillation/orbit paths |
| **Gaussian Splat Renderer** | Render frames from 3D representation |

**Camera Path Types:**
- `horizontal_oscillation` — Left-right sweep (default)
- `vertical_oscillation` — Up-down sweep
- `circular` — Gentle orbit
- `push_pull` — Zoom in-out
- `figure_eight` — Complex path

### Output Nodes (Parallax Studio/Output)

| Node | Description |
|------|-------------|
| **Video Encode** | Encode frames to video (H.264, H.265, VP9, ProRes) |
| **Save Video** | Save to output folder |
| **Preview Video** | Preview in ComfyUI |
| **Loop Video** | Extend video by looping |

### Utility Nodes (Parallax Studio/Utils)

| Node | Description |
|------|-------------|
| **Image Bypass Switch** | Toggle Qwen enhancement on/off |
| **Crop to Aspect Ratio** | 16:9, 21:9, 32:9, or custom |

---

## Parameters Guide

### Qwen-Image-Edit
| Parameter | Range | Default | Notes |
|-----------|-------|---------|-------|
| cfg_scale | 1-10 | 4.0 | Higher = stronger prompt adherence |
| steps | 20-100 | 50 | More steps = better quality, slower |
| seed | 0-2B | 0 | For reproducibility |

### Camera Path
| Parameter | Range | Default | Notes |
|-----------|-------|---------|-------|
| amplitude | 0.01-0.5 | 0.15 | How far camera moves |
| total_frames | 30-1800 | 300 | 300 @ 30fps = 10 second loop |
| fps | 24-60 | 30 | Frame rate |
| easing | sinusoidal/linear | sinusoidal | Motion smoothness |

### Video Encode
| Parameter | Options | Default | Notes |
|-----------|---------|---------|-------|
| codec | libx264, libx265, VP9, ProRes | libx264 | H.264 is most compatible |
| crf | 0-51 | 18 | Lower = better quality, larger file |
| preset | ultrafast-veryslow | slow | Slower = better compression |

---

## Tips for Best Results

### Image Selection
✓ Choose images with clear depth layers (foreground/middle/background)
✓ Landscapes, cityscapes, interiors work great
✓ Higher resolution input = better output
✗ Avoid flat subjects (documents, walls)
✗ Avoid heavy reflections or transparency

### Qwen Enhancement
- **Skip it** if your source image is already beautiful
- **Use it** to transform mundane photos into art
- **"Dramatic Sky"** adds visual interest to boring skies
- **"Add Fog"** actually enhances depth perception

### Parallax Settings
- Start with amplitude **0.10-0.15** (subtle)
- Increase to **0.25-0.40** only if effect is too weak
- Longer loops (**15-20 sec**) feel more ambient
- Shorter loops (**5-8 sec**) feel more dynamic

### Output
- **32:9 @ 5120×1440** for video walls
- Use **CRF 15-18** for high quality
- **CRF 22-25** for smaller files
- Loop 3-5x for longer ambient playback

---

## Troubleshooting

### "CUDA out of memory"
- Close other GPU applications
- Use `--lowvram` flag when launching ComfyUI
- Reduce output resolution
- Process in Half resolution first

### "Qwen model download failed"
- Check internet connection
- Ensure 50GB+ free disk space
- Try: `huggingface-cli login` first

### "SHARP checkpoint not found"
- Download manually:
  ```
  huggingface-cli download apple/Sharp sharp_2572gikvuh.pt --local-dir models/sharp
  ```

### "FFmpeg not found"
- Install FFmpeg: https://ffmpeg.org/download.html
- Or: `pip install imageio-ffmpeg`

### Video is black
- Check gsplat installation: `pip install gsplat`
- Verify CUDA is working: `python -c "import torch; print(torch.cuda.is_available())"`

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| GPU | RTX 3090 (24GB) | RTX 4090/5090 (24-32GB) |
| RAM | 32GB | 64GB+ |
| Storage | 50GB free | 100GB+ SSD |
| OS | Windows 10/11 | Windows 11 |

---

## Credits

- **Apple SHARP**: [arxiv.org/abs/2512.10685](https://arxiv.org/abs/2512.10685)
- **Qwen-Image-Edit**: [Qwen Team](https://huggingface.co/Qwen/Qwen-Image-Edit)
- **ComfyUI**: [github.com/comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **gsplat**: [github.com/nerfstudio-project/gsplat](https://github.com/nerfstudio-project/gsplat)

---

## License

Parallax Studio nodes are provided under MIT License.
Models used (SHARP, Qwen) are subject to their respective licenses.

---

*Built for the RTX 5090 Lab — Transform photos into living displays.*
