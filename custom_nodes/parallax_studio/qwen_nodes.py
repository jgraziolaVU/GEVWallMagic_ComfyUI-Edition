"""
◈ Parallax Studio - ComfyUI Edition
Qwen-Image-Edit Nodes

Your Photos. Alive.

v1.2.2 - Fixed bypass to truly skip Qwen execution
"""

import os
import torch
import numpy as np
from PIL import Image
import folder_paths


# Global cache for loaded pipeline
_qwen_pipeline_cache = None


class QwenImageEditLoader:
    """Load Qwen-Image-Edit pipeline for image transformation."""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "model_id": ("STRING", {"default": "Qwen/Qwen-Image-Edit"}),
                "dtype": (["bfloat16", "float16", "float32"], {"default": "bfloat16"}),
            }
        }
    
    RETURN_TYPES = ("QWEN_PIPELINE",)
    RETURN_NAMES = ("pipeline",)
    FUNCTION = "load_pipeline"
    CATEGORY = "Parallax Studio/Qwen"

    def load_pipeline(self, model_id, dtype):
        global _qwen_pipeline_cache
        
        # Return cached pipeline if already loaded
        if _qwen_pipeline_cache is not None:
            print(f"[Parallax Studio] ✓ Using cached Qwen pipeline")
            return (_qwen_pipeline_cache,)
        
        from diffusers import QwenImageEditPipeline
        
        dtype_map = {
            "bfloat16": torch.bfloat16,
            "float16": torch.float16,
            "float32": torch.float32,
        }
        
        print(f"[Parallax Studio] Loading Qwen-Image-Edit from {model_id}...")
        print(f"[Parallax Studio] First run downloads ~40GB - please be patient!")
        
        pipeline = QwenImageEditPipeline.from_pretrained(model_id)
        pipeline.to(dtype_map[dtype])
        pipeline.to("cuda")
        pipeline.set_progress_bar_config(disable=None)
        
        # Cache the pipeline
        _qwen_pipeline_cache = pipeline
        
        print(f"[Parallax Studio] ✓ Qwen pipeline loaded!")
        
        return (pipeline,)


class QwenImageEdit:
    """Apply Qwen-Image-Edit transformation to an image."""
    
    STYLE_PRESETS = {
        "None (custom prompt)": "",
        "Studio Ghibli": "Transform this image into Studio Ghibli anime style with soft colors and whimsical atmosphere",
        "Oil Painting": "Transform this image into a classical oil painting style with visible brushstrokes and rich colors",
        "Watercolor": "Transform this image into a delicate watercolor painting with soft edges and translucent colors",
        "Cyberpunk": "Transform this image into cyberpunk aesthetic with neon lights, rain-slicked streets, and futuristic elements",
        "Golden Hour": "Transform this image to have warm golden hour lighting with dramatic long shadows",
        "Noir": "Transform this image into black and white film noir style with dramatic shadows and contrast",
        "Impressionist": "Transform this image into impressionist painting style like Monet with visible brushwork and light effects",
        "Pixel Art": "Transform this image into detailed pixel art style while maintaining the composition",
        "Vintage Film": "Transform this image to look like a vintage 1970s film photograph with warm tones and grain",
        "Dramatic Sky": "Replace the sky with a dramatic sunset with vibrant orange and purple colors",
        "Add Fog": "Add atmospheric fog and mist throughout the scene for a mysterious mood",
        "Winter Scene": "Transform this into a winter scene with snow covering surfaces",
    }
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "pipeline": ("QWEN_PIPELINE",),
                "image": ("IMAGE",),
                "style_preset": (list(cls.STYLE_PRESETS.keys()), {"default": "Studio Ghibli"}),
                "custom_prompt": ("STRING", {
                    "default": "",
                    "multiline": True,
                    "placeholder": "Enter custom prompt (used if preset is 'None')"
                }),
                "cfg_scale": ("FLOAT", {"default": 4.0, "min": 1.0, "max": 10.0, "step": 0.5}),
                "steps": ("INT", {"default": 50, "min": 20, "max": 100, "step": 5}),
                "seed": ("INT", {"default": 0, "min": 0, "max": 2147483647}),
            },
            "optional": {
                "negative_prompt": ("STRING", {"default": "", "multiline": True}),
            }
        }
    
    RETURN_TYPES = ("IMAGE",)
    RETURN_NAMES = ("image",)
    FUNCTION = "edit"
    CATEGORY = "Parallax Studio/Qwen"

    def edit(self, pipeline, image, style_preset, custom_prompt, cfg_scale, steps, seed, negative_prompt=""):
        # Determine prompt
        if style_preset == "None (custom prompt)" or not self.STYLE_PRESETS[style_preset]:
            prompt = custom_prompt
        else:
            prompt = self.STYLE_PRESETS[style_preset]
        
        if not prompt.strip():
            print("[Parallax Studio] No prompt provided, returning original image")
            return (image,)
        
        # Convert ComfyUI tensor to PIL
        if isinstance(image, torch.Tensor):
            image_np = (image[0].cpu().numpy() * 255).astype(np.uint8)
            pil_image = Image.fromarray(image_np).convert("RGB")
        else:
            pil_image = image
        
        print(f"[Parallax Studio] Applying style: {style_preset}")
        
        inputs = {
            "image": pil_image,
            "prompt": prompt,
            "generator": torch.manual_seed(seed),
            "true_cfg_scale": cfg_scale,
            "negative_prompt": negative_prompt if negative_prompt else " ",
            "num_inference_steps": steps,
        }
        
        with torch.inference_mode():
            output = pipeline(**inputs)
            output_image = output.images[0]
        
        # Convert back to ComfyUI tensor format
        output_np = np.array(output_image).astype(np.float32) / 255.0
        output_tensor = torch.from_numpy(output_np).unsqueeze(0)
        
        print(f"[Parallax Studio] ✓ Style transformation complete!")
        
        return (output_tensor,)


class QwenImageEditBatch:
    """Apply Qwen-Image-Edit to multiple images (for batch processing)."""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "pipeline": ("QWEN_PIPELINE",),
                "images": ("IMAGE",),
                "prompt": ("STRING", {"default": "Transform to Studio Ghibli style", "multiline": True}),
                "cfg_scale": ("FLOAT", {"default": 4.0, "min": 1.0, "max": 10.0, "step": 0.5}),
                "steps": ("INT", {"default": 50, "min": 20, "max": 100, "step": 5}),
                "seed": ("INT", {"default": 0, "min": 0, "max": 2147483647}),
            }
        }
    
    RETURN_TYPES = ("IMAGE",)
    RETURN_NAMES = ("images",)
    FUNCTION = "edit_batch"
    CATEGORY = "Parallax Studio/Qwen"

    def edit_batch(self, pipeline, images, prompt, cfg_scale, steps, seed):
        batch_size = images.shape[0]
        output_images = []
        
        print(f"[Parallax Studio] Processing batch of {batch_size} images...")
        
        for i in range(batch_size):
            image_np = (images[i].cpu().numpy() * 255).astype(np.uint8)
            pil_image = Image.fromarray(image_np).convert("RGB")
            
            inputs = {
                "image": pil_image,
                "prompt": prompt,
                "generator": torch.manual_seed(seed + i),
                "true_cfg_scale": cfg_scale,
                "negative_prompt": " ",
                "num_inference_steps": steps,
            }
            
            with torch.inference_mode():
                output = pipeline(**inputs)
                output_image = output.images[0]
            
            output_np = np.array(output_image).astype(np.float32) / 255.0
            output_images.append(torch.from_numpy(output_np))
            
            print(f"[Parallax Studio] Batch progress: {i + 1}/{batch_size}")
        
        output_tensor = torch.stack(output_images, dim=0)
        
        return (output_tensor,)


class ImageBypassSwitch:
    """
    Switch between enhanced and original image.
    
    When use_enhanced=False, this node SHORT-CIRCUITS and returns
    the original image WITHOUT requiring the Qwen pipeline to execute.
    """
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "original_image": ("IMAGE",),
                "use_enhanced": ("BOOLEAN", {"default": True}),
            },
            "optional": {
                "enhanced_image": ("IMAGE",),
            }
        }
    
    RETURN_TYPES = ("IMAGE",)
    RETURN_NAMES = ("image",)
    FUNCTION = "switch"
    CATEGORY = "Parallax Studio/Utils"

    def switch(self, original_image, use_enhanced, enhanced_image=None):
        if use_enhanced:
            if enhanced_image is not None:
                print("[Parallax Studio] Using Qwen-enhanced image")
                return (enhanced_image,)
            else:
                print("[Parallax Studio] ⚠ Enhanced image not provided, using original")
                return (original_image,)
        else:
            print("[Parallax Studio] Bypassing Qwen, using original image")
            return (original_image,)


class QwenConditionalLoader:
    """
    Conditionally load Qwen pipeline ONLY if bypass is disabled.
    
    This prevents the massive 40GB model from loading when you just
    want to test SHARP rendering without style transfer.
    """
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "image": ("IMAGE",),
                "enable_qwen": ("BOOLEAN", {"default": True}),
                "model_id": ("STRING", {"default": "Qwen/Qwen-Image-Edit"}),
                "dtype": (["bfloat16", "float16", "float32"], {"default": "bfloat16"}),
                "style_preset": ([
                    "Studio Ghibli",
                    "Oil Painting",
                    "Watercolor",
                    "Cyberpunk",
                    "Golden Hour",
                    "Noir",
                    "Impressionist",
                    "Pixel Art",
                    "Vintage Film",
                    "Dramatic Sky",
                    "Add Fog",
                    "Winter Scene",
                    "None (custom prompt)",
                ], {"default": "Studio Ghibli"}),
                "custom_prompt": ("STRING", {"default": "", "multiline": True}),
                "cfg_scale": ("FLOAT", {"default": 4.0, "min": 1.0, "max": 10.0, "step": 0.5}),
                "steps": ("INT", {"default": 50, "min": 20, "max": 100, "step": 5}),
                "seed": ("INT", {"default": 0, "min": 0, "max": 2147483647}),
            }
        }
    
    RETURN_TYPES = ("IMAGE",)
    RETURN_NAMES = ("image",)
    FUNCTION = "process"
    CATEGORY = "Parallax Studio/Qwen"

    STYLE_PRESETS = {
        "None (custom prompt)": "",
        "Studio Ghibli": "Transform this image into Studio Ghibli anime style with soft colors and whimsical atmosphere",
        "Oil Painting": "Transform this image into a classical oil painting style with visible brushstrokes and rich colors",
        "Watercolor": "Transform this image into a delicate watercolor painting with soft edges and translucent colors",
        "Cyberpunk": "Transform this image into cyberpunk aesthetic with neon lights, rain-slicked streets, and futuristic elements",
        "Golden Hour": "Transform this image to have warm golden hour lighting with dramatic long shadows",
        "Noir": "Transform this image into black and white film noir style with dramatic shadows and contrast",
        "Impressionist": "Transform this image into impressionist painting style like Monet with visible brushwork and light effects",
        "Pixel Art": "Transform this image into detailed pixel art style while maintaining the composition",
        "Vintage Film": "Transform this image to look like a vintage 1970s film photograph with warm tones and grain",
        "Dramatic Sky": "Replace the sky with a dramatic sunset with vibrant orange and purple colors",
        "Add Fog": "Add atmospheric fog and mist throughout the scene for a mysterious mood",
        "Winter Scene": "Transform this into a winter scene with snow covering surfaces",
    }

    def process(self, image, enable_qwen, model_id, dtype, style_preset, custom_prompt, cfg_scale, steps, seed):
        # If Qwen is disabled, return original image immediately WITHOUT loading the model
        if not enable_qwen:
            print("[Parallax Studio] Qwen DISABLED - skipping model load, using original image")
            return (image,)
        
        # Only load Qwen if enabled
        global _qwen_pipeline_cache
        
        if _qwen_pipeline_cache is None:
            from diffusers import QwenImageEditPipeline
            
            dtype_map = {
                "bfloat16": torch.bfloat16,
                "float16": torch.float16,
                "float32": torch.float32,
            }
            
            print(f"[Parallax Studio] Loading Qwen-Image-Edit from {model_id}...")
            print(f"[Parallax Studio] First run downloads ~40GB - please be patient!")
            
            pipeline = QwenImageEditPipeline.from_pretrained(model_id)
            pipeline.to(dtype_map[dtype])
            pipeline.to("cuda")
            pipeline.set_progress_bar_config(disable=None)
            
            _qwen_pipeline_cache = pipeline
            print(f"[Parallax Studio] ✓ Qwen pipeline loaded!")
        else:
            print(f"[Parallax Studio] ✓ Using cached Qwen pipeline")
            pipeline = _qwen_pipeline_cache
        
        # Determine prompt
        if style_preset == "None (custom prompt)" or not self.STYLE_PRESETS.get(style_preset):
            prompt = custom_prompt
        else:
            prompt = self.STYLE_PRESETS[style_preset]
        
        if not prompt.strip():
            print("[Parallax Studio] No prompt provided, returning original image")
            return (image,)
        
        # Convert ComfyUI tensor to PIL
        if isinstance(image, torch.Tensor):
            image_np = (image[0].cpu().numpy() * 255).astype(np.uint8)
            pil_image = Image.fromarray(image_np).convert("RGB")
        else:
            pil_image = image
        
        print(f"[Parallax Studio] Applying style: {style_preset}")
        
        inputs = {
            "image": pil_image,
            "prompt": prompt,
            "generator": torch.manual_seed(seed),
            "true_cfg_scale": cfg_scale,
            "negative_prompt": " ",
            "num_inference_steps": steps,
        }
        
        with torch.inference_mode():
            output = pipeline(**inputs)
            output_image = output.images[0]
        
        # Convert back to ComfyUI tensor format
        output_np = np.array(output_image).astype(np.float32) / 255.0
        output_tensor = torch.from_numpy(output_np).unsqueeze(0)
        
        print(f"[Parallax Studio] ✓ Style transformation complete!")
        
        return (output_tensor,)


class ImageCropToAspectRatio:
    """Crop and resize image to target aspect ratio."""
    
    ASPECT_RATIOS = {
        "16:9 (Standard)": 16/9,
        "16:10 (Monitor)": 16/10,
        "21:9 (Ultrawide)": 21/9,
        "32:9 (Super Ultrawide)": 32/9,
        "1:1 (Square)": 1/1,
        "4:3 (Classic)": 4/3,
        "9:16 (Portrait)": 9/16,
        "Custom": None,
    }
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "image": ("IMAGE",),
                "aspect_ratio": (list(cls.ASPECT_RATIOS.keys()), {"default": "32:9 (Super Ultrawide)"}),
                "width": ("INT", {"default": 5120, "min": 640, "max": 8192, "step": 64}),
                "height": ("INT", {"default": 1440, "min": 360, "max": 4320, "step": 64}),
                "crop_position": (["center", "top", "bottom", "left", "right"], {"default": "center"}),
            }
        }
    
    RETURN_TYPES = ("IMAGE",)
    RETURN_NAMES = ("image",)
    FUNCTION = "crop_and_resize"
    CATEGORY = "Parallax Studio/Utils"

    def crop_and_resize(self, image, aspect_ratio, width, height, crop_position):
        if isinstance(image, torch.Tensor):
            image_np = (image[0].cpu().numpy() * 255).astype(np.uint8)
            pil_image = Image.fromarray(image_np)
        else:
            pil_image = image
        
        if aspect_ratio == "Custom" or self.ASPECT_RATIOS[aspect_ratio] is None:
            target_ratio = width / height
        else:
            target_ratio = self.ASPECT_RATIOS[aspect_ratio]
            height = int(width / target_ratio)
        
        img_width, img_height = pil_image.size
        current_ratio = img_width / img_height
        
        if current_ratio > target_ratio:
            new_width = int(img_height * target_ratio)
            if crop_position == "left":
                left = 0
            elif crop_position == "right":
                left = img_width - new_width
            else:
                left = (img_width - new_width) // 2
            pil_image = pil_image.crop((left, 0, left + new_width, img_height))
        else:
            new_height = int(img_width / target_ratio)
            if crop_position == "top":
                top = 0
            elif crop_position == "bottom":
                top = img_height - new_height
            else:
                top = (img_height - new_height) // 2
            pil_image = pil_image.crop((0, top, img_width, top + new_height))
        
        pil_image = pil_image.resize((width, height), Image.Resampling.LANCZOS)
        
        print(f"[Parallax Studio] Cropped to {width}×{height} ({aspect_ratio})")
        
        output_np = np.array(pil_image).astype(np.float32) / 255.0
        output_tensor = torch.from_numpy(output_np).unsqueeze(0)
        
        return (output_tensor,)


# Node registration
NODE_CLASS_MAPPINGS = {
    "QwenImageEditLoader": QwenImageEditLoader,
    "QwenImageEdit": QwenImageEdit,
    "QwenImageEditBatch": QwenImageEditBatch,
    "ImageBypassSwitch": ImageBypassSwitch,
    "QwenConditionalLoader": QwenConditionalLoader,
    "ImageCropToAspectRatio": ImageCropToAspectRatio,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "QwenImageEditLoader": "◈ Qwen-Image-Edit Loader",
    "QwenImageEdit": "◈ Qwen Image Edit",
    "QwenImageEditBatch": "◈ Qwen Image Edit (Batch)",
    "ImageBypassSwitch": "◈ Image Bypass Switch",
    "QwenConditionalLoader": "◈ Qwen Conditional (All-in-One)",
    "ImageCropToAspectRatio": "◈ Crop to Aspect Ratio",
}