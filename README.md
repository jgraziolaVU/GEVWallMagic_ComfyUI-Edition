# ◈ Parallax Studio v1.2 — ComfyUI Edition

### *Your Photos. Alive.*

Transform any photograph into a living, depth-enhanced video display. Perfect for immersive LED walls, digital art installations, or creative storytelling.

---

## What Is This?

Parallax Studio combines two cutting-edge AI models to breathe life into static images:

1. **Qwen-Image-Edit** applies artistic styles (anime, oil painting, cyberpunk, etc.)
2. **Apple SHARP** extracts 3D depth and generates realistic camera motion

The result? Photos that move with cinematic parallax, as if you're looking through a window into another world.

**ComfyUI Edition** = The power user version with a visual node-based interface for complete control and experimentation.

---

## Quick Start

### Step 1: Install (20-40 minutes)

Double-click `install_comfyui.bat`

**What it does:**
- Installs Python 3.11 environment
- Downloads PyTorch with CUDA support
- Installs ComfyUI and dependencies
- Downloads SHARP model (~500MB)
- Sets up custom nodes

**First-time users:** Just keep clicking "Next" when installers appear. Everything else is automatic.

### Step 2: Launch

Double-click **"Parallax Studio (ComfyUI)"** on your Desktop

A terminal window opens and starts the server. **Don't close this window** — it needs to stay open while you work.

### Step 3: Open Browser

Go to **http://127.0.0.1:8188**

You'll see the ComfyUI interface with a grid of connected nodes.

### Step 4: Load Workflow

1. Click **Load** (top menu)
2. Select **parallax_workflow.json**
3. The complete workflow appears with all nodes connected

### Step 5: Create Your First Video

1. **Upload your image:** Click the **Load Image** node → choose your photo
2. **Choose enhancement:** Toggle the **Image Bypass Switch** ON (uses Qwen) or OFF (skip enhancement)
3. **Click "Queue Prompt"** (right sidebar)
4. **Wait for processing:**
   - **First run only:** Qwen model downloads (~45-50GB, takes 1-3 hours depending on internet)
   - **Subsequent runs:** 10-30 seconds per image after models are cached

**Progress appears in the terminal window and browser interface.**

---

## Understanding the Workflow
```
┌─────────────────┐
│  Your Photo     │
└────────┬────────┘
         ↓
┌─────────────────────────────────────┐
│ ◈ Qwen-Image-Edit (Optional)        │  ← Applies artistic style
│   • Studio Ghibli                   │
│   • Oil painting                    │
│   • Cyberpunk, etc.                 │
└────────┬────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ ◈ Apple SHARP                       │  ← Extracts 3D depth
│   • Analyzes depth layers           │
│   • Creates 3D Gaussian splat       │
└────────┬────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ ◈ Camera Path Generator             │  ← Defines motion
│   • Horizontal sweep (default)      │
│   • Vertical, circular, zoom, etc.  │
└────────┬────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ ◈ Video Renderer                    │  ← Creates frames
│   • Renders from new viewpoints     │
│   • Smooth parallax motion          │
└────────┬────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ ◈ Video Encoder (FFmpeg)            │  ← Exports final video
│   • H.264, H.265, ProRes            │
│   • Custom resolution & bitrate     │
└────────┬────────────────────────────┘
         ↓
    Final MP4 Video
```

---

## Folder Structure
```
C:\Users\[USERNAME]\ParallaxStudio-ComfyUI\
├── ComfyUI\                         ← Main ComfyUI installation
│   ├── custom_nodes\
│   │   └── parallax_studio\
│   │       ├── __init__.py          ← Node registration
│   │       ├── qwen_nodes.py        ← Style transfer nodes
│   │       ├── sharp_nodes.py       ← 3D depth extraction nodes
│   │       └── video_nodes.py       ← Video encoding nodes
│   ├── models\
│   │   └── sharp\
│   │       └── sharp_2572gikvuh.pt  ← SHARP checkpoint (~500MB)
│   └── user\
│       └── default\
│           └── workflows\
│               └── parallax_workflow.json  ← Pre-built workflow
└── run_comfyui.bat                  ← Launcher script
```

**Your project source files location:**
```
[YOUR_PROJECT_PATH]\GEVWallMagic_ComfyUI-Edition-main\
└── custom_nodes\
    └── parallax_studio\            ← Source files (copy to ComfyUI installation)
```

---

## Custom Nodes Reference

### Parallax Studio / Qwen

**What Qwen does:** Transforms your photo's artistic style using a 72-billion parameter vision-language model from Alibaba Cloud.

| Node | Purpose | Technical Details |
|------|---------|-------------------|
| **◈ Qwen-Image-Edit Loader** | Loads the Qwen model into VRAM | One-time load per session, ~45-50GB model |
| **◈ Qwen Image Edit** | Applies style presets or custom text prompts | 50 diffusion steps, CFG scale 1-10 |
| **◈ Qwen Image Edit (Batch)** | Process multiple images sequentially | Reuses loaded model for efficiency |
| **◈ Image Bypass Switch** | Toggle enhancement ON/OFF without rewiring | Boolean switch, no model loading when OFF |
| **◈ Crop to Aspect Ratio** | Prepare images for specific displays | 16:10, 16:9, 21:9, 32:9, custom ratios |

**Technical note:** Qwen uses Stable Diffusion-based image editing with IP-Adapter for style guidance. First run downloads 9 safetensors files (~5GB each) from Hugging Face.

---

### Parallax Studio / SHARP

**What SHARP does:** Apple's "Splat-based Adaptive Refinement for Parallax" converts 2D images into 3D Gaussian splat representations for view synthesis.

| Node | Purpose | Technical Details |
|------|---------|-------------------|
| **◈ SHARP Model Loader** | Loads Apple SHARP checkpoint | ~500MB, loads in ~2-3 seconds |
| **◈ SHARP Predict** | Generates 3D Gaussian splat from image | Creates point cloud with opacity, color, scale per Gaussian |
| **◈ Parallax Camera Path** | Defines camera movement trajectory | Configurable amplitude, easing, path type |
| **◈ Gaussian Splat Renderer** | Renders frames from 3D representation | Differentiable rasterization via gsplat library |
| **◈ Save Gaussian Splat** | Exports .ply point cloud file | Standard PLY format, importable to Blender/CloudCompare |

**Technical note:** SHARP uses 3D Gaussian splatting (not NeRF or depth maps), which provides smoother parallax with fewer artifacts. Each Gaussian is a colored, oriented ellipsoid positioned in 3D space.

---

### Parallax Studio / Output

| Node | Purpose | Technical Details |
|------|---------|-------------------|
| **◈ Video Encode** | Encodes frame sequence to video | FFmpeg with hardware acceleration (NVENC on NVIDIA) |
| **◈ Save Video** | Writes video to output folder | Configurable path, auto-creates directories |
| **◈ Preview Video** | Displays video in ComfyUI interface | Browser-compatible format |
| **◈ Loop Video** | Creates seamless loops | Reverses frame sequence for ping-pong effect |

---

## Aspect Ratios Explained

The **Crop to Aspect Ratio** node intelligently prepares your images for different display types:

| Ratio | Resolution Examples | Common Use Cases |
|-------|---------------------|------------------|
| **16:10** | 1920×1200, 2560×1600, 3840×2400 | Professional monitors, MacBook Pro, Dell UltraSharp displays |
| **16:9** | 1920×1080, 2560×1440, 3840×2160 | Standard HD/4K displays, TVs, most consumer monitors |
| **21:9** | 2560×1080, 3440×1440, 5120×2160 | Ultrawide monitors, cinematic displays |
| **32:9** | 3840×1080, 5120×1440, 7680×2160 | Super-ultrawide monitors, multi-monitor replacement |
| **9:16** | 1080×1920, 1440×2560, 2160×3840 | Vertical/portrait displays, mobile content, digital signage |
| **4:3** | 1024×768, 1600×1200, 2048×1536 | Legacy monitors, some industrial displays |
| **1:1** | 1080×1080, 2160×2160 | Square displays, Instagram posts |

**How it works:** The node crops from the center while preserving the most visually important content. For custom ratios not listed, you can manually specify width:height values (e.g., "2.39:1" for anamorphic widescreen).

---

## Style Presets Explained

| Preset | Visual Effect | Technical Implementation |
|--------|---------------|--------------------------|
| **Studio Ghibli** | Soft anime aesthetic, hand-painted look | Guided diffusion with Ghibli film reference embeddings |
| **Oil Painting** | Thick brushstrokes, classical art | Texture synthesis with impasto patterns |
| **Watercolor** | Soft, translucent colors, paper texture | Reduced saturation, edge bleeding simulation |
| **Cyberpunk** | Neon lights, futuristic urban decay | Color grading (cyan/magenta), bloom effects |
| **Golden Hour** | Warm sunset lighting, long shadows | Color temperature shift (2000-3000K), increased contrast |
| **Dramatic Sky** | Epic cloud formations, enhanced atmosphere | Sky segmentation + replacement with generated clouds |
| **Add Fog** | Atmospheric mist, depth haze | Distance-based alpha blending |
| **Noir** | High-contrast black & white, dramatic shadows | Desaturation + gamma curve adjustment |
| **Impressionist** | Monet-style brushwork, dappled light | Brush stroke synthesis, color palette matching |
| **Vintage Film** | 1970s film stock look, grain | Film grain noise, vignetting, color fade |
| **Winter Scene** | Snow coverage, cold color cast | Semantic segmentation + snow texture overlay |

**Custom prompts:** You can also type your own instructions like "make it look like a Renaissance painting" or "add northern lights to the sky."

---

## Camera Path Types

| Path | Motion Description | Use Case |
|------|-------------------|----------|
| `horizontal_oscillation` | Smooth left-right sweep (default) | Most photos, landscape orientation |
| `vertical_oscillation` | Smooth up-down sweep | Portrait photos, vertical compositions |
| `circular` | Gentle orbital motion around center | Centered subjects, 360° reveals |
| `push_pull` | Zoom in and out | Dramatic reveals, establishing shots |
| `figure_eight` | Complex infinity-loop path | Dynamic scenes, music videos |

**Custom paths:** Advanced users can define custom camera trajectories by modifying the camera position arrays in the node.

---

## Parameters Guide

### Qwen Image Edit Parameters

| Parameter | Range | Default | What It Does |
|-----------|-------|---------|--------------|
| **cfg_scale** | 1.0 - 10.0 | 4.0 | **Guidance strength:** How closely to follow the style prompt. Lower = creative interpretation, Higher = strict adherence |
| **steps** | 20 - 100 | 50 | **Diffusion steps:** More steps = better quality but slower. 30 = fast preview, 50 = production, 75+ = diminishing returns |
| **seed** | 0 - 4,294,967,295 | 0 (random) | **Random seed:** Use the same seed to reproduce exact results. 0 = new random seed each time |
| **strength** | 0.0 - 1.0 | 0.8 | **Edit intensity:** 0 = no change, 1 = complete transformation. Use 0.5-0.7 for subtle enhancements |

**Example settings:**
- **Quick preview:** steps=30, cfg_scale=3.0
- **Production quality:** steps=50, cfg_scale=4.0
- **Maximum quality:** steps=75, cfg_scale=5.0

---

### Parallax Camera Path Parameters

| Parameter | Range | Default | What It Does |
|-----------|-------|---------|--------------|
| **amplitude** | 0.01 - 0.5 | 0.15 | **Parallax intensity:** How far the camera moves. 0.1 = subtle, 0.2 = dramatic. Too high creates distortion |
| **total_frames** | 30 - 1800 | 300 | **Video length:** At 30fps, 300 frames = 10 seconds. 600 = 20 seconds, etc. |
| **fps** | 24 - 60 | 30 | **Frame rate:** 24 = cinematic, 30 = standard, 60 = smooth (requires 2x frames) |
| **easing** | sinusoidal / linear / ease_in_out | sinusoidal | **Motion curve:** Sinusoidal = smooth start/stop, Linear = constant speed, Ease = gradual acceleration |
| **loop** | true / false | false | **Seamless loop:** Reverses motion at end for perfect loops |

**Timing calculations:**
- 10 seconds @ 30fps = 300 frames
- 20 seconds @ 30fps = 600 frames
- 10 seconds @ 60fps = 600 frames

**Amplitude recommendations by display:**
- Desktop monitor (16:9, 16:10): 0.10 - 0.15
- LED video wall (21:9, 32:9): 0.15 - 0.25
- Immersive theater: 0.20 - 0.30

---

### Video Encode Parameters

| Parameter | Options | Default | What It Does |
|-----------|---------|---------|--------------|
| **codec** | H.264, H.265 (HEVC), VP9, ProRes 422 | H.264 | **Compression format:** H.264 = universal compatibility, H.265 = better compression, ProRes = professional editing |
| **crf** | 0 - 51 | 18 | **Quality level:** 0 = lossless (huge files), 18 = visually lossless, 23 = good, 28+ = visible artifacts. Lower = better |
| **preset** | ultrafast - veryslow | slow | **Encoding speed:** Ultrafast = quick but large files, Slow = optimal compression, Veryslow = marginal gains |
| **pix_fmt** | yuv420p, yuv444p | yuv420p | **Color subsampling:** 420 = standard compatibility, 444 = higher color fidelity (larger files) |

**Codec recommendations:**
- **Social media:** H.264, CRF 23, preset medium
- **LED display:** H.264, CRF 18, preset slow
- **Archival:** H.265, CRF 20, preset slow
- **Editing workflow:** ProRes 422, preset slow

**File size estimates (1920×1080, 10 seconds):**
- CRF 18 (visually lossless): ~50-100MB
- CRF 23 (good quality): ~20-40MB
- CRF 28 (medium quality): ~10-20MB

---

## Technical Specifications

### AI Models Used

| Model | Parameters | Size on Disk | VRAM Usage | Purpose |
|-------|-----------|--------------|------------|---------|
| **Qwen2.5-72B-Instruct** | 72 billion | ~45-50GB | ~40GB | Style transfer, image editing |
| **Qwen Image-Edit VAE** | - | ~5GB | ~2GB | Latent encoding/decoding |
| **Apple SHARP** | ~100 million | ~500MB | ~3-5GB | Monocular view synthesis |

**Total installation size:** ~60-70GB (models + dependencies)

**Runtime VRAM usage:**
- Qwen only: ~42GB
- SHARP only: ~5GB
- Both loaded: ~47GB (exceeds 24GB cards, models swap to RAM)

---

### System Requirements

| Component | Minimum | Recommended | Optimal |
|-----------|---------|-------------|---------|
| **GPU** | RTX 3090 (24GB VRAM) | RTX A6000 (48GB) | RTX 4090 (24GB) or 5090 (32GB) |
| **RAM** | 32GB | 64GB | 128GB+ |
| **Storage** | 60GB free (HDD) | 100GB SSD | 200GB NVMe SSD |
| **CPU** | 6-core Intel/AMD | 8-core | 12+ core |
| **OS** | Windows 10 (64-bit) | Windows 11 | Windows 11 Pro |
| **Internet** | Required for initial setup | 100+ Mbps for fast model downloads | - |

**GPU Notes:**
- **24GB cards (RTX 3090, 4090):** Can run both models but will swap to RAM (slower). Consider processing in two stages.
- **48GB cards (RTX A6000, A100):** Optimal. Both models fit in VRAM simultaneously.
- **12GB cards:** Not recommended. Will be very slow or run out of memory.

**Why so much VRAM?** Qwen is a massive 72-billion parameter model. Most consumer image models are 1-7 billion parameters.

---

## First Run: What to Expect

### Timeline

| Stage | Duration | What's Happening |
|-------|----------|------------------|
| **Installer** | 20-40 min | Downloads PyTorch, ComfyUI, dependencies |
| **First launch** | 2-3 min | ComfyUI starts, scans for nodes |
| **Qwen download** | 1-3 hours | Downloads 45-50GB model (one-time only) |
| **First image processing** | 2-3 hours | Qwen runs at full 50 diffusion steps |
| **Subsequent runs** | 10-30 sec | Models cached, CUDA kernels compiled |

**Why is the first run so slow?**
1. **Model download:** 45-50GB over your internet connection
2. **CUDA compilation:** PyTorch compiles GPU kernels (one-time)
3. **Memory optimization:** System figures out optimal VRAM allocation
4. **Model loading:** Initial load from disk to VRAM (~2 minutes)

**After the first image:** Processing drops to 10-30 seconds because everything is cached and optimized.

---

## Troubleshooting

### "CUDA out of memory"

**What it means:** Your GPU doesn't have enough VRAM to hold the models.

**Solutions (try in order):**

1. **Skip Qwen enhancement:**
   - Set Image Bypass Switch to OFF
   - This reduces VRAM usage from 47GB → 5GB

2. **Enable low VRAM mode:**
   - Edit `run_comfyui.bat`
   - Change `--highvram` to `--lowvram`
   - Models will swap to RAM (slower but works)

3. **Close other GPU applications:**
   - Chrome with hardware acceleration
   - Other AI applications
   - Games running in background

4. **Process in stages:**
   - Run Qwen first, save image
   - Close ComfyUI
   - Reload and run SHARP on the saved image

5. **Reduce output resolution:**
   - Qwen VRAM usage scales with image size
   - Try 720p instead of 1080p for testing

---

### "Node not found" or "Module import error"

**What it means:** ComfyUI can't find your custom nodes.

**Solutions:**

1. **Verify files are in correct location:**
```
   C:\Users\[USERNAME]\ParallaxStudio-ComfyUI\ComfyUI\custom_nodes\parallax_studio\
   ├── __init__.py
   ├── qwen_nodes.py
   ├── sharp_nodes.py
   └── video_nodes.py
```

2. **Restart ComfyUI completely:**
   - Close the terminal window
   - Relaunch from Desktop shortcut

3. **Check for Python errors:**
   - Look in the terminal window for error messages
   - Common issues: missing dependencies, import errors

4. **Reinstall custom nodes:**
   Copy the files from your source directory to the ComfyUI custom_nodes folder

---

### "Qwen download slow" or "Download failed"

**What it means:** Downloading 45-50GB from Hugging Face can be slow or interrupted.

**Solutions:**

1. **Be patient:**
   - 45-50GB takes time even on fast connections
   - 100 Mbps = ~1 hour minimum
   - 50 Mbps = ~2 hours
   - 25 Mbps = ~4 hours

2. **Use Hugging Face CLI (more reliable):**
```batch
   conda activate parallax_comfyui
   huggingface-cli login
   huggingface-cli download Qwen/Qwen-Image-Edit --local-dir C:\Users\[USERNAME]\.cache\huggingface\hub
```

3. **Check firewall/antivirus:**
   - Some security software blocks large downloads
   - Temporarily disable and retry

4. **Resume interrupted downloads:**
   - Hugging Face downloads resume automatically
   - Just run the workflow again, it continues where it left off

---

### "SHARP checkpoint missing"

**What it means:** The SHARP model file wasn't downloaded during installation.

**Manual download:**
```batch
conda activate parallax_comfyui
python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='apple/Sharp', filename='sharp_2572gikvuh.pt', local_dir='C:/Users/[USERNAME]/ParallaxStudio-ComfyUI/ComfyUI/models/sharp')"
```

Or download directly:
1. Go to https://huggingface.co/apple/Sharp
2. Download `sharp_2572gikvuh.pt` (~500MB)
3. Place in `ComfyUI\models\sharp\`

---

### "Video encoding failed"

**What it means:** FFmpeg encountered an error during video export.

**Solutions:**

1. **Check output path permissions:**
   - Ensure the output folder is writable
   - Try saving to Desktop temporarily

2. **Verify FFmpeg installation:**
```batch
   conda activate parallax_comfyui
   ffmpeg -version
```

3. **Try different codec:**
   - H.264 is most compatible
   - If H.265 fails, switch to H.264

4. **Reduce video settings:**
   - Lower resolution
   - Fewer frames
   - Higher CRF value (faster encoding)

---

### "ComfyUI won't start"

**What it means:** The server isn't launching properly.

**Solutions:**

1. **Check if port 8188 is already in use:**
```batch
   netstat -ano | findstr :8188
```
   - If something is using it, close that application
   - Or change ComfyUI port: `python main.py --port 8189`

2. **Verify conda environment:**
```batch
   conda activate parallax_comfyui
   python --version
```
   - Should show Python 3.11.x

3. **Reinstall PyTorch:**
```batch
   conda activate parallax_comfyui
   pip uninstall torch torchvision torchaudio -y
   pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121
```

4. **Check for error messages:**
   - Read the terminal output carefully
   - Look for "ModuleNotFoundError" or "ImportError"

---

## Performance Tips

### Optimize for Speed

✓ **Skip Qwen when not needed**
- Toggle bypass OFF for faster processing
- Only use style transfer when you want artistic effects

✓ **Lower resolution for testing**
- Process at 720p during experimentation
- Use full resolution only for final export

✓ **Reduce Qwen steps**
- 30 steps = fast preview (~1 minute)
- 40 steps = good quality (~2 minutes)
- 50 steps = production (~3 minutes)
- 60+ steps = diminishing returns

✓ **Use efficient video codecs**
- H.264 with preset "medium" for fast encoding
- Only use "slow" or "veryslow" for final export

✓ **Batch processing**
- Process multiple images in sequence
- Models stay loaded in VRAM (much faster)

### Optimize for Quality

✓ **Use higher Qwen steps**
- 50-75 steps for production work
- Results plateau around 75 steps

✓ **Lower CRF values**
- CRF 15-18 for LED display (visually lossless)
- CRF 18-20 for archival

✓ **Higher camera path frame counts**
- 300 frames minimum
- 600+ frames for ultra-smooth motion

✓ **Increase parallax amplitude carefully**
- Start at 0.15, adjust based on image depth
- Too high creates distortion artifacts

### Optimize for VRAM

✓ **Close other applications**
- Chrome, Discord, etc. can use 1-2GB VRAM

✓ **Process in stages**
- Qwen → save → close → SHARP
- Keeps VRAM usage under 24GB per stage

✓ **Use `--lowvram` flag**
- Edit launcher script
- Swaps models to RAM when not in use

---

## Advanced Workflows

### Multiple Style Variations

**Goal:** Generate 5 different styles from one photo

**Setup:**
1. Load image once
2. Connect to 5 parallel Qwen nodes with different style presets
3. Each feeds into separate SHARP → Video pipelines
4. Export 5 videos simultaneously

**Benefit:** Models load once, process multiple variations

---

### Custom Camera Choreography

**Goal:** Complex multi-phase camera movement

**Setup:**
1. Create multiple camera path nodes:
   - Path 1: Horizontal sweep (frames 0-100)
   - Path 2: Push in (frames 100-200)
   - Path 3: Circular (frames 200-300)
2. Concatenate frame sequences
3. Export as single video

**Benefit:** Cinematic camera work beyond simple paths

---

### Interactive Style Mixing

**Goal:** Blend two styles (50% Ghibli + 50% Cyberpunk)

**Setup:**
1. Run Qwen twice with different styles
2. Use Image Blend node (ComfyUI built-in)
3. Set blend factor to 0.5
4. Feed blended result to SHARP

**Benefit:** Unique hybrid aesthetics

---

### Depth Map Export

**Goal:** Extract depth map for use in other applications

**Setup:**
1. Run SHARP Predict node
2. Connect to "Save Gaussian Splat" node
3. Export .ply file
4. Import into Blender, CloudCompare, or MeshLab

**Benefit:** Use depth data in 3D software, VFX pipelines

---

## Understanding the Technology

### What is Gaussian Splatting?

**Traditional 3D methods:**
- **Mesh:** Polygons connected in 3D space (what most 3D models use)
- **NeRF:** Neural network that learns 3D scene representation
- **Depth maps:** 2D image where each pixel stores distance

**Gaussian Splatting:**
- Represents 3D scene as millions of tiny colored "splats"
- Each splat is a 3D ellipsoid (stretched sphere) with:
  - Position (X, Y, Z)
  - Color (R, G, B)
  - Opacity (how transparent)
  - Orientation (which direction it faces)
  - Scale (how big in each dimension)

**Why it's better for parallax:**
- Renders new viewpoints faster than NeRF (real-time vs. minutes)
- Smoother than depth maps (no hard edges or disocclusion artifacts)
- Naturally handles semi-transparent objects (glass, fog, etc.)

**Analogy:** Imagine millions of colored cotton balls floating in space. When you move the camera, they rearrange naturally to form the image from the new angle.

---

### How Does Style Transfer Work?

**Qwen-Image-Edit process:**

1. **Encode:** Converts your image to a "latent" representation (compressed mathematical form)
2. **Inject style:** Uses a language model to understand "Studio Ghibli" and guide the transformation
3. **Diffuse:** Gradually adds noise, then removes it while following style guidance
4. **Decode:** Converts latent back to viewable image

**Why 50 steps?** Each step refines the image slightly. More steps = more detail but slower.

**CFG scale:** Controls how strictly to follow the prompt. Higher = more faithful to style description.

---

### System Architecture
```
┌─────────────────────────────────────────────────────┐
│                   Your Computer                     │
│                                                     │
│  ┌─────────────┐         ┌──────────────────────┐  │
│  │   CPU       │────────▶│  System RAM (64GB+)  │  │
│  │   Manages   │         │  • Model loading     │  │
│  │   workflow  │         │  • Frame buffering   │  │
│  └─────────────┘         └──────────────────────┘  │
│         │                                           │
│         ▼                                           │
│  ┌──────────────────────────────────────────────┐  │
│  │   GPU (RTX A6000, 48GB VRAM)                 │  │
│  │                                              │  │
│  │   ┌──────────────────────────────────────┐  │  │
│  │   │  Qwen Model (45-50GB)                │  │  │
│  │   │  • Transformer layers                │  │  │
│  │   │  • Attention mechanisms              │  │  │
│  │   │  • Diffusion scheduler               │  │  │
│  │   └──────────────────────────────────────┘  │  │
│  │                                              │  │
│  │   ┌──────────────────────────────────────┐  │  │
│  │   │  SHARP Model (3GB)                   │  │  │
│  │   │  • Feature extraction                │  │  │
│  │   │  • Gaussian optimization             │  │  │
│  │   └──────────────────────────────────────┘  │  │
│  │                                              │  │
│  │   ┌──────────────────────────────────────┐  │  │
│  │   │  Rendering Pipeline                  │  │  │
│  │   │  • Rasterization (gsplat)            │  │  │
│  │   │  • Frame buffer                      │  │  │
│  │   └──────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────┘  │
│         │                                           │
│         ▼                                           │
│  ┌─────────────┐                                   │
│  │  SSD/NVMe   │                                   │
│  │  • Models   │                                   │
│  │  • Output   │                                   │
│  └─────────────┘                                   │
└─────────────────────────────────────────────────────┘
```

---

## Tips for Best Results

### Image Selection

✓ **Good candidates:**
- Landscapes with clear foreground/background separation
- Portraits with visible depth (blurred background)
- Architecture with geometric structure
- Nature scenes with layered elements

✗ **Challenging images:**
- Flat textures (walls, solid colors)
- Extreme close-ups with no depth cues
- Motion blur or very low resolution
- Highly abstract or monochromatic images

### Style Selection

✓ **Matches your content:**
- Landscapes → Watercolor, Impressionist, Golden Hour
- Urban scenes → Cyberpunk, Noir, Vintage Film
- Portraits → Studio Ghibli, Oil Painting
- Nature → Watercolor, Impressionist, Winter Scene

✓ **Consider your display:**
- Bright room → High contrast styles (Cyberpunk, Noir)
- Dim room → Soft styles (Watercolor, Ghibli)
- Large LED wall → Dramatic styles (Golden Hour, Dramatic Sky)

### Camera Motion

✓ **Match image composition:**
- Horizontal landscapes → Horizontal oscillation
- Tall buildings → Vertical oscillation
- Centered subjects → Circular or push_pull
- Dynamic scenes → Figure_eight

✓ **Amplitude guidelines:**
- Subtle depth → 0.10 - 0.15
- Medium depth → 0.15 - 0.20
- Deep layers → 0.20 - 0.30
- **Never exceed 0.35** (causes distortion)

### Video Export

✓ **For LED displays:**
- Codec: H.264
- CRF: 18
- Preset: slow
- Resolution: Match your display
  - 16:10 pro monitors: 1920×1200, 2560×1600
  - 32:9 super-ultrawide: 7680×2160

✓ **For social media:**
- Codec: H.264
- CRF: 23
- Preset: medium
- Resolution: 1920×1080 (landscape) or 1080×1920 (portrait)

✓ **For archival:**
- Codec: H.265 or ProRes 422
- CRF: 15-18
- Preset: slow or veryslow

---

## Keyboard Shortcuts (ComfyUI)

| Key | Action |
|-----|--------|
| **Ctrl + Enter** | Queue prompt (start processing) |
| **Ctrl + Shift + Enter** | Queue prompt (front of queue) |
| **Ctrl + S** | Save workflow |
| **Ctrl + O** | Open workflow |
| **Ctrl + A** | Select all nodes |
| **Delete** | Delete selected nodes |
| **Ctrl + C / V** | Copy / Paste nodes |
| **Ctrl + D** | Duplicate selected nodes |
| **Double-click canvas** | Add node menu |
| **Ctrl + Mouse wheel** | Zoom in/out |
| **Space + Drag** | Pan canvas |

---

## Workflow Best Practices

### Save Your Work

✓ **Save frequently**
- Use descriptive names: `portrait_ghibli_v2.json`
- Create workflow variations for different styles
- Keep a "template" workflow for quick starts

✓ **Version control**
- Save before major changes
- Number your versions: `_v1`, `_v2`, `_v3`

### Organize Your Nodes

✓ **Group related nodes**
- Use "Reroute" nodes to clean up connections
- Add "Note" nodes to document settings
- Color-code node groups (right-click → Color)

✓ **Label your nodes**
- Right-click → Title
- Use descriptions like "Input Image" or "Final Output"

### Test Before Full Processing

✓ **Use preview nodes**
- Add "Preview Image" nodes at key stages
- Verify style before committing to full render

✓ **Test with low settings**
- Qwen: 30 steps, 720p
- SHARP: 100 frames instead of 300
- Verify everything works, then increase quality

---

## Getting Help

### Resources

- **ComfyUI Documentation:** [https://docs.comfy.org](https://docs.comfy.org)
- **ComfyUI Discord:** [https://discord.gg/comfyui](https://discord.gg/comfyui)
- **Apple SHARP Paper:** [arxiv.org/abs/2512.10685](https://arxiv.org/abs/2512.10685)
- **Qwen Model Page:** [huggingface.co/Qwen/Qwen-Image-Edit](https://huggingface.co/Qwen/Qwen-Image-Edit)

### Common Questions

**Q: Can I use this commercially?**
A: Check licenses for each model. Qwen and SHARP have research licenses; commercial use may require permission.

**Q: Can I run this on AMD/Intel GPUs?**
A: No. CUDA-only (NVIDIA required). ROCm support (AMD) is not implemented.

**Q: Can I use this on Mac?**
A: Not currently. Requires CUDA. MPS (Metal) support could be added but performance would be poor on unified memory.

**Q: How do I make longer videos?**
A: Increase `total_frames` in Camera Path node. 30fps × 600 frames = 20 seconds.

**Q: Can I import my own 3D models?**
A: SHARP generates 3D from photos, doesn't import. Export .ply from SHARP to use in other software.

**Q: Why is my GPU at 100% but rendering is slow?**
A: Normal. Diffusion and rendering are computationally intensive. First run is slowest.

**Q: Does the Crop to Aspect Ratio node support 16:10?**
A: Yes! 16:10 is fully supported along with 16:9, 21:9, 32:9, 9:16, 4:3, 1:1, and custom ratios.

---

## Credits & Acknowledgments

**AI Models:**
- **Apple SHARP** — Apple Machine Learning Research (2024)
  - Paper: "Splat-based Adaptive Refinement for Parallax"
  - [arxiv.org/abs/2512.10685](https://arxiv.org/abs/2512.10685)
  
- **Qwen-Image-Edit** — Alibaba Cloud Qwen Team (2024)
  - Model: Qwen2.5-72B-Instruct with image editing capabilities
  - [huggingface.co/Qwen/Qwen-Image-Edit](https://huggingface.co/Qwen/Qwen-Image-Edit)

**Core Technologies:**
- **ComfyUI** — Node-based Stable Diffusion GUI
  - [github.com/comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
  
- **gsplat** — Gaussian Splatting CUDA kernels
  - Nerfstudio Project
  - [github.com/nerfstudio-project/gsplat](https://github.com/nerfstudio-project/gsplat)
  
- **PyTorch** — Deep learning framework
  - [pytorch.org](https://pytorch.org)
  
- **FFmpeg** — Video encoding
  - [ffmpeg.org](https://ffmpeg.org)

**Libraries & Dependencies:**
- Hugging Face Transformers & Diffusers
- NumPy, SciPy, Pillow
- CUDA Toolkit (NVIDIA)

---

## License

**Parallax Studio custom nodes:** MIT License (open source)

**Third-party components:**
- ComfyUI: GPL-3.0
- SHARP: Research use only (Apple)
- Qwen: Research license (Alibaba Cloud)
- gsplat: Apache 2.0

**For commercial use:** Review individual model licenses and obtain necessary permissions.

---

<p align="center">
<b>◈ Parallax Studio v1.2 — ComfyUI Edition</b><br>
<i>Your Photos. Alive.</i><br><br>
Developed for immersive LED displays, digital art installations, and creative storytelling.<br>
Optimized for NVIDIA RTX A6000 (48GB VRAM) and RTX 4090/5090 GPUs.
</p>

---

## Quick Reference Card

**First-Time Setup:**
1. Run `install_comfyui.bat` (20-40 min)
2. Launch from Desktop shortcut
3. Open http://127.0.0.1:8188
4. Load `parallax_workflow.json`
5. First run downloads Qwen (~45-50GB, 1-3 hours)

**Daily Workflow:**
1. Load image → Set style → Queue prompt
2. Processing time: 10-30 seconds (after first run)
3. Output: MP4 video with parallax motion

**Essential Paths:**
- Custom nodes: `ComfyUI\custom_nodes\parallax_studio\`
- Models: `ComfyUI\models\sharp\`
- Workflows: `ComfyUI\user\default\workflows\`
- Output: `ComfyUI\output\`

**Key Settings:**
- Qwen steps: 50 (production), 30 (preview)
- Camera amplitude: 0.15 (standard), 0.20 (dramatic)
- Video CRF: 18 (LED display), 23 (web)
- Frame count: 300 = 10 sec @ 30fps

**Supported Aspect Ratios:**
- 16:10 (pro monitors), 16:9 (standard), 21:9 (ultrawide)
- 32:9 (super-ultrawide), 9:16 (portrait), 4:3, 1:1, custom

**Troubleshooting:**
- Out of memory → Skip Qwen or use `--lowvram`
- Slow first run → Normal, downloads + compiles
- Node errors → Check file locations, restart ComfyUI
