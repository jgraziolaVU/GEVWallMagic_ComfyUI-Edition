"""
◈ Parallax Studio - ComfyUI Edition
Video Encoding Nodes

Your Photos. Alive.
"""

import os
import torch
import numpy as np
from PIL import Image
import subprocess
import tempfile
from pathlib import Path
import folder_paths


class VideoEncode:
    """Encode image frames to video using FFmpeg."""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "frames": ("IMAGE",),
                "fps": ("INT", {"default": 30, "min": 1, "max": 120, "step": 1}),
                "codec": (["libx264", "libx265", "libvpx-vp9", "prores"], {"default": "libx264"}),
                "crf": ("INT", {"default": 18, "min": 0, "max": 51, "step": 1}),
                "preset": (["ultrafast", "fast", "medium", "slow", "veryslow"], {"default": "slow"}),
                "pixel_format": (["yuv420p", "yuv444p", "rgb24"], {"default": "yuv420p"}),
            }
        }
    
    RETURN_TYPES = ("VIDEO",)
    RETURN_NAMES = ("video",)
    FUNCTION = "encode"
    CATEGORY = "Parallax Studio/Output"

    def encode(self, frames, fps, codec, crf, preset, pixel_format):
        num_frames = frames.shape[0]
        height, width = frames.shape[1], frames.shape[2]
        
        print(f"[Parallax Studio] Encoding {num_frames} frames at {width}×{height}, {fps}fps...")
        
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            frames_dir = temp_path / "frames"
            frames_dir.mkdir()
            
            # Save frames as images
            print("[Parallax Studio] Saving frames...")
            for i in range(num_frames):
                frame_np = (frames[i].cpu().numpy() * 255).astype(np.uint8)
                frame_img = Image.fromarray(frame_np)
                frame_img.save(frames_dir / f"frame_{i:05d}.png")
            
            output_path = temp_path / "output.mp4"
            
            # Build FFmpeg command
            cmd = [
                "ffmpeg", "-y",
                "-framerate", str(fps),
                "-i", str(frames_dir / "frame_%05d.png"),
                "-c:v", codec,
                "-pix_fmt", pixel_format,
            ]
            
            if codec in ["libx264", "libx265"]:
                cmd.extend(["-crf", str(crf), "-preset", preset])
            elif codec == "libvpx-vp9":
                cmd.extend(["-crf", str(crf), "-b:v", "0"])
            elif codec == "prores":
                cmd.extend(["-profile:v", "3"])
            
            cmd.append(str(output_path))
            
            print(f"[Parallax Studio] Running FFmpeg...")
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode != 0:
                raise RuntimeError(f"FFmpeg failed: {result.stderr}")
            
            with open(output_path, "rb") as f:
                video_bytes = f.read()
        
        video_data = {
            "bytes": video_bytes,
            "fps": fps,
            "width": width,
            "height": height,
            "num_frames": num_frames,
            "codec": codec,
            "duration": num_frames / fps,
        }
        
        size_mb = len(video_bytes) / 1024 / 1024
        print(f"[Parallax Studio] ✓ Video encoded: {video_data['duration']:.1f}s, {size_mb:.1f}MB")
        
        return (video_data,)


class SaveVideo:
    """Save encoded video to file."""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "video": ("VIDEO",),
                "filename_prefix": ("STRING", {"default": "parallax_video"}),
                "format": (["mp4", "mov", "webm"], {"default": "mp4"}),
            }
        }
    
    RETURN_TYPES = ()
    OUTPUT_NODE = True
    FUNCTION = "save"
    CATEGORY = "Parallax Studio/Output"

    def save(self, video, filename_prefix, format):
        output_dir = folder_paths.get_output_directory()
        
        # Find next available filename
        counter = 1
        while True:
            filename = f"{filename_prefix}_{counter:04d}.{format}"
            filepath = os.path.join(output_dir, filename)
            if not os.path.exists(filepath):
                break
            counter += 1
        
        # Write video file
        with open(filepath, "wb") as f:
            f.write(video["bytes"])
        
        print(f"[Parallax Studio] ✓ Saved video: {filepath}")
        print(f"[Parallax Studio]   {video['width']}×{video['height']}, {video['fps']}fps, {video['duration']:.1f}s")
        
        return {"ui": {"videos": [{"filename": filename, "subfolder": "", "type": "output"}]}}


class VideoPreview:
    """Preview video in ComfyUI."""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "video": ("VIDEO",),
            }
        }
    
    RETURN_TYPES = ()
    OUTPUT_NODE = True
    FUNCTION = "preview"
    CATEGORY = "Parallax Studio/Output"

    def preview(self, video):
        temp_dir = folder_paths.get_temp_directory()
        filename = f"preview_{id(video)}.mp4"
        filepath = os.path.join(temp_dir, filename)
        
        with open(filepath, "wb") as f:
            f.write(video["bytes"])
        
        return {"ui": {"videos": [{"filename": filename, "subfolder": "", "type": "temp"}]}}


class LoopVideo:
    """Create seamlessly looped video by extending duration."""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "video": ("VIDEO",),
                "loop_count": ("INT", {"default": 3, "min": 1, "max": 20, "step": 1}),
            }
        }
    
    RETURN_TYPES = ("VIDEO",)
    RETURN_NAMES = ("video",)
    FUNCTION = "loop"
    CATEGORY = "Parallax Studio/Output"

    def loop(self, video, loop_count):
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            
            input_path = temp_path / "input.mp4"
            with open(input_path, "wb") as f:
                f.write(video["bytes"])
            
            concat_file = temp_path / "concat.txt"
            with open(concat_file, "w") as f:
                for _ in range(loop_count):
                    f.write(f"file '{input_path}'\n")
            
            output_path = temp_path / "looped.mp4"
            
            cmd = [
                "ffmpeg", "-y",
                "-f", "concat",
                "-safe", "0",
                "-i", str(concat_file),
                "-c", "copy",
                str(output_path)
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode != 0:
                raise RuntimeError(f"FFmpeg concat failed: {result.stderr}")
            
            with open(output_path, "rb") as f:
                looped_bytes = f.read()
        
        looped_video = {
            "bytes": looped_bytes,
            "fps": video["fps"],
            "width": video["width"],
            "height": video["height"],
            "num_frames": video["num_frames"] * loop_count,
            "codec": video["codec"],
            "duration": video["duration"] * loop_count,
        }
        
        print(f"[Parallax Studio] ✓ Looped {loop_count}x: {looped_video['duration']:.1f}s")
        
        return (looped_video,)


# Node registration
NODE_CLASS_MAPPINGS = {
    "VideoEncode": VideoEncode,
    "SaveVideo": SaveVideo,
    "VideoPreview": VideoPreview,
    "LoopVideo": LoopVideo,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "VideoEncode": "◈ Video Encode (FFmpeg)",
    "SaveVideo": "◈ Save Video",
    "VideoPreview": "◈ Preview Video",
    "LoopVideo": "◈ Loop Video",
}
