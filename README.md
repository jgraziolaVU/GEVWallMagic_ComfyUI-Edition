# ◈ Parallax Studio v1.2 — ComfyUI Edition

### *Your Photos. Alive.*

---

## What Is This?

The **power user version** of Parallax Studio.

Same magic — transform any photo into a living, breathing display with real depth — but with a node-based interface that lets you experiment, chain additional models, and build custom workflows.

---

## Quick Start

### Step 1: Install

Double-click `install_comfyui.bat` and wait 20-40 minutes.

### Step 2: Run

Double-click **"Parallax Studio (ComfyUI)"** on your Desktop.

### Step 3: Open Browser

Go to **http://127.0.0.1:8188**

### Step 4: Load Workflow

Click **Load** → select **parallax_workflow.json**

### Step 5: Create

1. Load your image into the **LoadImage** node
2. Toggle Qwen enhancement ON/OFF with the **Bypass Switch**
3. Click **Queue Prompt**
4. Wait for magic

---

## Folder Structure

```
ParallaxStudio-ComfyUI/
├── custom_nodes/
│   └── parallax_studio/
│       ├── __init__.py          ← Node registration
│       ├── qwen_nodes.py        ← Style transfer nodes
│       ├── sharp_nodes.py       ← 3D extraction nodes
│       └── video_nodes.py       ← Video encoding nodes
├── workflows/
│   └── parallax_workflow.json   ← Pre-built workflow
├── install_comfyui.bat          ← One-click installer
└── README.md                    ← You're reading it
```

---

## Custom Nodes

### Parallax Studio/Qwen

| Node | Description |
|------|-------------|
| **◈ Qwen-Image-Edit Loader** | Load the 20B Qwen model |
| **◈ Qwen Image Edit** | Apply style presets or custom prompts |
| **◈ Qwen Image Edit (Batch)** | Process multiple images |
| **◈ Image Bypass Switch** | Toggle enhancement ON/OFF |
| **◈ Crop to Aspect Ratio** | 16:9, 21:9, 32:9, custom |

### Parallax Studio/SHARP

| Node | Description |
|------|-------------|
| **◈ SHARP Model Loader** | Load Apple SHARP checkpoint |
| **◈ SHARP Predict** | Extract 3D Gaussian Splat |
| **◈ Parallax Camera Path** | Generate motion paths |
| **◈ Gaussian Splat Renderer** | Render frames from 3D |
| **◈ Save Gaussian Splat** | Export .ply file |

### Parallax Studio/Output

| Node | Description |
|------|-------------|
| **◈ Video Encode** | FFmpeg encoding (H.264, H.265, VP9, ProRes) |
| **◈ Save Video** | Save to output folder |
| **◈ Preview Video** | Preview in ComfyUI |
| **◈ Loop Video** | Extend by looping |

---

## Style Presets

| Preset | Effect |
|--------|--------|
| Studio Ghibli | Soft anime aesthetic |
| Oil Painting | Classical brushstrokes |
| Watercolor | Soft, translucent colors |
| Cyberpunk | Neon lights, futuristic |
| Golden Hour | Warm sunset lighting |
| Dramatic Sky | Epic sky replacement |
| Add Fog | Atmospheric mist |
| Noir | Black & white drama |
| Impressionist | Monet-style brushwork |
| Vintage Film | 1970s film look |
| Winter Scene | Snow coverage |

---

## Camera Paths

| Path | Motion |
|------|--------|
| `horizontal_oscillation` | Left-right sweep (default) |
| `vertical_oscillation` | Up-down sweep |
| `circular` | Gentle orbit |
| `push_pull` | Zoom in-out |
| `figure_eight` | Complex path |

---

## Parameters Guide

### Qwen Image Edit

| Parameter | Range | Default | Notes |
|-----------|-------|---------|-------|
| cfg_scale | 1-10 | 4.0 | Higher = stronger style |
| steps | 20-100 | 50 | More = better quality |
| seed | 0-2B | 0 | For reproducibility |

### Parallax Camera Path

| Parameter | Range | Default | Notes |
|-----------|-------|---------|-------|
| amplitude | 0.01-0.5 | 0.15 | Depth intensity |
| total_frames | 30-1800 | 300 | 300 @ 30fps = 10s |
| fps | 24-60 | 30 | Frame rate |
| easing | sinusoidal/linear | sinusoidal | Motion smoothness |

### Video Encode

| Parameter | Options | Default | Notes |
|-----------|---------|---------|-------|
| codec | H.264, H.265, VP9, ProRes | H.264 | Compatibility |
| crf | 0-51 | 18 | Lower = better quality |
| preset | ultrafast-veryslow | slow | Compression efficiency |

---

## Why ComfyUI?

**Experimentation** — Drag wires, try things, see what happens

**Extensibility** — Add ControlNet, upscalers, other models later

**Transparency** — See exactly what's connected to what

**Power** — Fine-tune every parameter

**Reproducibility** — Save workflows, share with others

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **GPU** | RTX 3090 (24GB) | RTX 4090/5090 |
| **RAM** | 32GB | 64GB+ |
| **Storage** | 60GB free | 100GB+ SSD |
| **OS** | Windows 10 | Windows 11 |

---

## Troubleshooting

### "CUDA out of memory"

- Close other GPU apps
- Use `--lowvram` flag when launching
- Reduce output resolution
- Process enhancement and rendering separately

### "Node not found"

- Ensure all files are in `custom_nodes/parallax_studio/`
- Restart ComfyUI after adding nodes
- Check ComfyUI console for error messages

### "Qwen download slow"

- It's 40GB — be patient
- Check internet connection
- Try `huggingface-cli login` first

### "SHARP checkpoint missing"

```bash
huggingface-cli download apple/Sharp sharp_2572gikvuh.pt --local-dir ComfyUI/models/sharp
```

---

## Tips

✓ **Start simple** — Use the pre-built workflow first

✓ **Toggle Qwen** — Set bypass to FALSE to skip enhancement

✓ **Preview first** — Use low resolution for test renders

✓ **Save workflows** — Keep variations for different styles

✗ **Don't close the window** — ComfyUI runs in the terminal

---

## Credits

- **Apple SHARP** — [arxiv.org/abs/2512.10685](https://arxiv.org/abs/2512.10685)
- **Qwen-Image-Edit** — [Alibaba Qwen Team](https://huggingface.co/Qwen/Qwen-Image-Edit)
- **ComfyUI** — [github.com/comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **gsplat** — [github.com/nerfstudio-project/gsplat](https://github.com/nerfstudio-project/gsplat)

---

<p align="center">
<b>◈ Parallax Studio v1.2 — ComfyUI Edition</b><br>
<i>Your Photos. Alive.</i>
</p>
