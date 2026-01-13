"""
Parallax Studio - ComfyUI Custom Nodes
Version 1.2

A complete pipeline for creating depth-enhanced parallax videos
by chaining Qwen-Image-Edit and Apple SHARP.

Installation:
    Place this folder in ComfyUI/custom_nodes/parallax_studio/

Nodes included:
    - Qwen-Image-Edit Loader: Load the Qwen image editing model
    - Qwen Image Edit: Apply style transfer and image edits
    - SHARP Model Loader: Load Apple SHARP for 3D extraction
    - SHARP Predict: Extract 3D Gaussian Splat from image
    - Parallax Camera Path: Generate camera motion paths
    - Gaussian Splat Renderer: Render frames from 3D representation
    - Video Encode: Encode frames to video with FFmpeg
    - Save Video: Save video to output folder
    - Plus utility nodes for cropping, switching, looping

GitHub: https://github.com/your-repo/parallax-studio-comfyui
"""

from .qwen_nodes import NODE_CLASS_MAPPINGS as QWEN_NODES
from .qwen_nodes import NODE_DISPLAY_NAME_MAPPINGS as QWEN_DISPLAY
from .sharp_nodes import NODE_CLASS_MAPPINGS as SHARP_NODES
from .sharp_nodes import NODE_DISPLAY_NAME_MAPPINGS as SHARP_DISPLAY
from .video_nodes import NODE_CLASS_MAPPINGS as VIDEO_NODES
from .video_nodes import NODE_DISPLAY_NAME_MAPPINGS as VIDEO_DISPLAY

# Combine all node mappings
NODE_CLASS_MAPPINGS = {
    **QWEN_NODES,
    **SHARP_NODES,
    **VIDEO_NODES,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    **QWEN_DISPLAY,
    **SHARP_DISPLAY,
    **VIDEO_DISPLAY,
}

# Web extensions (if any UI customization needed)
WEB_DIRECTORY = "./web"

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS", "WEB_DIRECTORY"]

# Version info
__version__ = "1.2.0"
__author__ = "Villanova GIS Lab"

print(f"\n{'='*60}")
print(f"  ◈ PARALLAX STUDIO v{__version__} loaded!")
print(f"  Nodes: {len(NODE_CLASS_MAPPINGS)} custom nodes registered")
print(f"  Category: Parallax Studio/*")
print(f"{'='*60}\n")
