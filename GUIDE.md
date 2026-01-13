# 🎨 Parallax Studio - The Friendly Guide

### *Make Your Photos Come Alive!*

**What does this do?** It turns your regular photos into videos that look 3D - like you're looking through a window! Perfect for showing off on big screens or just making cool videos.

---

## 📖 Table of Contents

1. [What You'll See](#what-youll-see)
2. [The Three Main Sections](#the-three-main-sections)
3. [Step-by-Step: Making Your First Video](#step-by-step-making-your-first-video)
4. [Understanding Each Box (Node)](#understanding-each-box-node)
5. [Common Tasks](#common-tasks)
6. [Troubleshooting](#troubleshooting)
7. [Tips for Best Results](#tips-for-best-results)

---

## What You'll See

When you open Parallax Studio, you'll see a screen with **colored boxes connected by lines**. Don't worry! It's simpler than it looks.

Think of it like a **recipe**:
- Each **box** is a step in the recipe
- The **lines** show how ingredients move from one step to the next
- Your photo goes in one side, a cool video comes out the other!

The boxes are organized in **three colored sections**:
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  1. BLUE AREA   │ →  │  2. PURPLE AREA │ →  │  3. GREEN AREA  │
│  Load & Style   │    │  Make it 3D     │    │  Create Video   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## The Three Main Sections

### 🔵 Section 1: INPUT & ENHANCEMENT (Blue Area - Left Side)

**What happens here:** You pick your photo and decide if you want to make it look artistic (like a cartoon or painting).

**The boxes you'll see:**
- **Load Image** - Where you pick your photo
- **Qwen-Image-Edit Loader** - Loads the "art style" tool
- **Qwen Image Edit** - Changes your photo to look like art
- **Bypass Switch** - A simple ON/OFF switch for the art effect
- **Crop to Aspect Ratio** - Cuts your photo to fit your screen

### 🟣 Section 2: 3D EXTRACTION (Purple Area - Middle)

**What happens here:** The computer figures out which parts of your photo are close and which are far away, then builds a 3D version.

**The boxes you'll see:**
- **SHARP Model Loader** - Loads the "3D magic" tool
- **SHARP Predict** - Creates the 3D version of your photo
- **Parallax Camera Path** - Decides how the camera will move

### 🟢 Section 3: RENDER & OUTPUT (Green Area - Right Side)

**What happens here:** The 3D version turns into a video, and you save it to your computer.

**The boxes you'll see:**
- **Gaussian Splat Renderer** - Creates the moving video frames
- **Video Encode** - Packages the frames into a video file
- **Save Video** - Saves the final video to your computer

---

## Step-by-Step: Making Your First Video

### 🎯 **Quick Version (Just 5 Steps!)**

1. **Click the "Load Image" box** → Choose your photo
2. **Look at the "Bypass Switch" box** → Make sure it says "true" (this turns ON the art effect)
3. **Scroll to the right** → Find the green "Save Video" box
4. **Click the "Queue Prompt" button** (in the right sidebar)
5. **Wait!** Your first time will take 1-3 hours. After that, only 10-30 seconds!

### 📝 **Detailed Version (With Explanations)**

---

### **STEP 1: Load Your Photo**

1. Find the **"Load Image"** box in the **blue area** (far left)
2. **Click anywhere inside the box**
3. A file browser will open - **find and select your photo**
4. Your photo will appear in the box!

**Tips for picking photos:**
- ✅ **Good choices:** Landscapes, portraits, buildings, nature
- ✅ **Best results:** Photos with clear foreground and background
- ❌ **Avoid:** Very blurry photos or solid colored walls

---

### **STEP 2: Choose Your Artistic Style (Optional)**

Look for the **"Qwen Image Edit"** box in the blue area.

**Inside this box, you'll see a dropdown menu** that says "Studio Ghibli". Click it to see other styles:

| Style | What It Looks Like |
|-------|-------------------|
| **Studio Ghibli** | Soft anime style (like the movie Totoro) |
| **Oil Painting** | Like a painting with brush strokes |
| **Watercolor** | Soft and dreamy, like watercolor paint |
| **Cyberpunk** | Futuristic with neon lights |
| **Golden Hour** | Warm sunset glow |
| **Dramatic Sky** | Big, epic clouds |
| **Add Fog** | Misty and atmospheric |
| **Noir** | Black and white, dramatic |
| **Impressionist** | Like Monet's paintings |
| **Vintage Film** | Old 1970s movie look |
| **Winter Scene** | Adds snow! |

**Pick any style you like**, or leave it as "Studio Ghibli"

---

### **STEP 3: Turn the Style ON or OFF**

Find the **"Image Bypass Switch"** box.

**You'll see a checkbox** that says "true" or "false":
- ✅ **true** = Style effect is ON (your photo will look artistic)
- ✅ **false** = Style effect is OFF (your photo stays normal, but still gets 3D motion)

**For your first try, leave it as "true"** to see the full effect!

**Why would you turn it OFF?**
- If you just want 3D motion without changing how your photo looks
- To make it process faster (skips the art step)
- If you have a professional photo that's already perfect

---

### **STEP 4: Choose Your Screen Size**

Find the **"Image Crop to Aspect Ratio"** box.

**Click the dropdown** and you'll see options like:

| Option | What It's For |
|--------|---------------|
| **16:10 (Professional Monitor)** | MacBook, Dell monitors |
| **16:9 (Standard)** | Most TVs and computer screens |
| **21:9 (Ultrawide)** | Wide gaming monitors |
| **32:9 (Super Ultrawide)** | Very wide curved monitors or LED walls |
| **9:16 (Portrait)** | Phone screens (vertical) |

**The default is set to 32:9** - a super wide screen like your LED wall!

**If you're making this for:**
- Your TV → Choose **16:9**
- Your phone → Choose **9:16**
- Your laptop → Choose **16:10** or **16:9**
- LED wall → Keep it at **32:9**

---

### **STEP 5: Choose Camera Movement**

Scroll to the **purple area** and find **"Parallax Camera Path"**

**You'll see a dropdown with these options:**

| Movement | What It Does | Best For |
|----------|--------------|----------|
| **horizontal_oscillation** | Camera moves left and right | Landscapes, wide photos |
| **vertical_oscillation** | Camera moves up and down | Tall buildings, portraits |
| **circular** | Camera circles around the center | Close-up of a person or object |
| **push_pull** | Zooms in and out | Dramatic effect, revealing depth |
| **figure_eight** | Does a figure-8 pattern | Complex, interesting motion |

**For your first video, leave it as "horizontal_oscillation"** (left-right movement)

**Also in this box:**
- **amplitude** - How far the camera moves (0.15 is a good starting point)
  - Smaller number (0.10) = gentle, subtle
  - Bigger number (0.25) = dramatic, obvious
- **total_frames** - How long your video is (300 = 10 seconds)
- **fps** - How smooth it is (30 is standard)

---

### **STEP 6: Start Making Your Video!**

**Now for the exciting part!**

1. **Look at the RIGHT side of your screen** for a sidebar
2. **Find the button that says "Queue Prompt"**
3. **Click it!**

**What happens next:**

A loading bar will appear and you'll see text scrolling in the **terminal window** (the black window that opened when you started Parallax Studio).

---

### **⏳ IMPORTANT: The First Run Takes A LONG Time!**

**Your VERY FIRST video will take 1-3 hours** because the computer has to download a huge 45-50GB "brain" (the Qwen model).

**You'll see:**
- Progress bars showing percentages
- Text saying "Downloading model..."
- Lots of numbers and file names

**This is NORMAL!** The computer is downloading and installing everything it needs.

**After the first time, it only takes 10-30 seconds!** The "brain" stays on your computer.

---

### **STEP 7: Your Video is Ready!**

When it's done, you'll see:
- Text saying "Saved to: parallax_output.mp4"
- The terminal stops scrolling

**Where is your video?**

Go to this folder on your computer:
```
C:\Users\[YOUR_USERNAME]\ParallaxStudio-ComfyUI\ComfyUI\output\
```

Look for a file called **parallax_output.mp4** - that's your video!

**Double-click it to watch!** 🎉

---

## Understanding Each Box (Node)

Let me explain what every box does in simple terms:

---

### 🔵 **BLUE SECTION: Load Your Photo & Make It Pretty**

#### **1. Load Image** 📷
**What it does:** This is where you pick your photo from your computer.

**What you see:**
- A thumbnail of your photo
- The filename

**What to click:**
- Click the box to choose a different photo
- The photo automatically connects to the next steps

---

#### **2. Qwen-Image-Edit Loader** 🧠
**What it does:** Loads the "art brain" - a huge AI model that can change your photo's style.

**What you see:**
- Model name: "Qwen/Qwen-Image-Edit"
- Precision: "bfloat16" (technical stuff - don't change it!)

**What to do:** 
- **Leave it alone!** It automatically loads when you start making a video
- **First time only:** This takes 1-3 hours to download

---

#### **3. Qwen Image Edit** 🎨
**What it does:** This is the **FUN PART** - it changes your photo to look like art!

**What you see:**

| Setting | What It Means |
|---------|---------------|
| **Style Preset** | The artistic style (Ghibli, Oil Painting, etc.) |
| **Custom Prompt** | Type your own instructions (like "make it look spooky") |
| **cfg_scale** | How strong the effect is (4.0 is good) |
| **steps** | How much time to spend (50 is good, 30 is faster) |
| **seed** | A magic number for making the same result twice (0 = random) |

**What to change:**
- **Style Preset** - Try different art styles!
- **Custom Prompt** - Type anything like "add rain" or "make it nighttime"
- **steps** - Lower to 30 for faster results, 50 for better quality

**What to leave alone:**
- cfg_scale (4.0 is the sweet spot)
- seed (unless you want to recreate the exact same result)

---

#### **4. Image Bypass Switch** 🔀
**What it does:** A simple ON/OFF switch for the art effect.

**What you see:**
- A checkbox: ☑️ true or ☐ false

**What it means:**
- ✅ **true (checked)** = Art effect is ON - your photo gets stylized
- ☐ **false (unchecked)** = Art effect is OFF - photo stays normal but still gets 3D motion

**When to turn it OFF (false):**
- You just want 3D motion without art
- You want faster processing
- Your photo is already perfect

**When to leave it ON (true):**
- You want cool artistic effects
- First time trying the app
- Making something for social media

---

#### **5. Image Crop to Aspect Ratio** ✂️
**What it does:** Cuts your photo to fit your screen perfectly (like trimming edges to fit a frame).

**What you see:**

| Setting | What It Means |
|---------|---------------|
| **Ratio** | The shape of your screen (32:9, 16:9, etc.) |
| **Width** | How many pixels wide (5120 is very wide) |
| **Height** | How many pixels tall (1440 is standard) |
| **Crop position** | Which part to keep ("center" keeps the middle) |

**Common choices:**

| Screen Type | Choose This |
|-------------|-------------|
| Regular TV or monitor | 16:9, width: 1920, height: 1080 |
| Laptop (MacBook) | 16:10, width: 1920, height: 1200 |
| Ultrawide monitor | 21:9, width: 2560, height: 1080 |
| Super wide LED wall | 32:9, width: 5120, height: 1440 |
| Phone (vertical) | 9:16, width: 1080, height: 1920 |

**Tips:**
- Choose the ratio that matches your screen
- Higher numbers = better quality but bigger file size
- "center" keeps the most important part of your photo

---

### 🟣 **PURPLE SECTION: Make It 3D**

#### **6. SHARP Model Loader** 🔮
**What it does:** Loads the "3D brain" - the AI that figures out depth in your photo.

**What you see:**
- Model filename: "sharp_2572gikvuh.pt"

**What to do:**
- **Nothing!** It loads automatically
- This loads fast (2-3 seconds) because it's only 500MB

---

#### **7. SHARP Predict** 🎯
**What it does:** The **MAGIC STEP** - it looks at your photo and figures out what's close and what's far away, then builds a 3D version.

**What you see:**
- Just the connections (no settings to change)

**How it works:**
1. Takes your photo
2. Analyzes depth (figures out 3D structure)
3. Creates millions of tiny colored "points" in 3D space
4. This becomes your 3D scene!

**Fun fact:** This uses something called "Gaussian Splatting" - imagine millions of tiny colored cotton balls floating in 3D space that form your image!

---

#### **8. Parallax Camera Path** 🎥
**What it does:** Decides how the camera moves through your 3D scene.

**What you see:**

| Setting | What It Means | Good Values |
|---------|---------------|-------------|
| **path_type** | What kind of movement | horizontal_oscillation |
| **amplitude** | How far the camera moves | 0.10 (subtle) to 0.25 (dramatic) |
| **total_frames** | How many frames = how long | 300 = 10 seconds, 600 = 20 seconds |
| **fps** | Frames per second (smoothness) | 30 (standard), 60 (very smooth) |
| **easing** | How motion starts/stops | sinusoidal (smooth) |

**Camera movements explained:**

| Movement | What You'll See |
|----------|-----------------|
| **horizontal_oscillation** | Camera sweeps left → right → left (like shaking your head "no") |
| **vertical_oscillation** | Camera sweeps up → down → up (like nodding "yes") |
| **circular** | Camera orbits in a circle around the center |
| **push_pull** | Camera zooms in → out → in (like leaning forward/back) |
| **figure_eight** | Camera traces a figure-8 pattern (complex, interesting) |

**How to pick amplitude:**

| Value | Effect | Best For |
|-------|--------|----------|
| 0.10 | Very subtle, gentle | Professional displays, subtle effect |
| 0.15 | Noticeable but natural | **DEFAULT - good starting point!** |
| 0.20 | Dramatic, obvious | Large LED walls, "wow factor" |
| 0.25 | Very dramatic | Maximum impact (but might distort) |
| 0.30+ | **TOO MUCH!** | Avoid - causes weird distortion |

**Video length:**
- 300 frames @ 30 fps = **10 seconds**
- 600 frames @ 30 fps = **20 seconds**
- 900 frames @ 30 fps = **30 seconds**

**Formula:** frames ÷ fps = seconds
- Want 15 seconds? → 15 × 30 = 450 frames

---

### 🟢 **GREEN SECTION: Make the Video**

#### **9. Gaussian Splat Renderer** 🖼️
**What it does:** Takes the 3D scene and the camera path, then creates every frame of your video.

**What you see:**

| Setting | What It Means |
|---------|---------------|
| **width** | Video width in pixels (5120 = very wide) |
| **height** | Video height in pixels (1440 = HD) |

**What to change:**
- Match these numbers to your screen size
- Bigger = better quality but slower and larger files
- These should match the crop settings from earlier

**Common sizes:**

| Screen | Width | Height |
|--------|-------|--------|
| Regular TV/monitor | 1920 | 1080 |
| MacBook | 1920 | 1200 |
| Ultrawide | 2560 | 1080 |
| Super ultrawide | 5120 | 1440 |
| 4K TV | 3840 | 2160 |

---

#### **10. Video Encode** 📦
**What it does:** Packages all those frames into a video file (like putting photos in a photo album).

**What you see:**

| Setting | What It Means | Good Values |
|---------|---------------|-------------|
| **fps** | Frames per second (same as camera path) | 30 |
| **codec** | Video format | libx264 (works everywhere) |
| **crf** | Quality (lower = better) | 18 (great quality) |
| **preset** | Speed vs file size | slow (good balance) |
| **pix_fmt** | Color format | yuv420p (standard) |

**Simple explanation:**
- **fps**: Match this to your camera path (usually 30)
- **codec**: libx264 = H.264 = works on all devices
- **crf**: Think of it like quality setting
  - 18 = Excellent (big file)
  - 23 = Good (smaller file)
  - 28 = Okay (even smaller)
- **preset**: How long to spend compressing
  - fast = quick but big file
  - slow = takes longer but smaller file
  - veryslow = REALLY long but smallest file

**For most people:** Leave these settings alone! They're already perfect.

---

#### **11. Save Video** 💾
**What it does:** Saves your finished video to your computer.

**What you see:**

| Setting | What It Means |
|---------|---------------|
| **filename_prefix** | What to call your video | parallax_output |
| **format** | File type | mp4 |

**What to change:**
- **filename_prefix** - Give your video a name!
  - Examples: "my_mountain_video", "birthday_photo", "vacation_memory"
  - Don't use spaces - use underscores: "my_video" not "my video"

**Where does it save?**
```
C:\Users\[YOUR_USERNAME]\ParallaxStudio-ComfyUI\ComfyUI\output\parallax_output.mp4
```

---

#### **12. Preview Image** 👁️
**What it does:** Shows you what your photo looks like after cropping (before it becomes 3D).

**What you see:**
- A preview of your cropped image
- Helps you see if the crop looks good

**What to do:**
- Just look at it!
- If it looks wrong, adjust the crop settings and try again

---

#### **13. Save Gaussian Splat** 📁
**What it does:** Saves the 3D data as a special file (.ply) that you can open in 3D software like Blender.

**What you see:**
- **filename_prefix**: What to call the file (parallax_3d)

**What's it for?**
- Advanced users who want to edit the 3D scene in other programs
- Most people can ignore this!
- The video works fine without it

**Where does it save?**
```
C:\Users\[YOUR_USERNAME]\ParallaxStudio-ComfyUI\ComfyUI\output\parallax_3d.ply
```

---

## Common Tasks

### 🎨 **Task 1: Change the Art Style**

**What you want:** Try different artistic looks (Ghibli, oil painting, etc.)

**Steps:**
1. Find the **"Qwen Image Edit"** box (blue section, near the top)
2. **Click the dropdown** that says "Studio Ghibli"
3. **Pick a different style** from the list
4. **Click "Queue Prompt"** (right sidebar)
5. Wait for your new video!

**Try these combinations:**
- Landscape photo + "Golden Hour" = Beautiful sunset glow
- Portrait photo + "Studio Ghibli" = Anime character
- City photo + "Cyberpunk" = Futuristic neon city
- Nature photo + "Watercolor" = Dreamy painting

---

### 🎥 **Task 2: Change Camera Movement**

**What you want:** Make the camera move differently (up/down instead of left/right, etc.)

**Steps:**
1. Find **"Parallax Camera Path"** box (purple section)
2. **Click the dropdown** that says "horizontal_oscillation"
3. **Choose a different movement:**
   - vertical_oscillation = up and down
   - circular = spins around
   - push_pull = zooms in and out
   - figure_eight = figure-8 pattern
4. **Click "Queue Prompt"**

**Pro tip:** Try circular motion for portraits (people's faces) - it looks amazing!

---

### ⚡ **Task 3: Make It Faster (Skip the Art Effect)**

**What you want:** Just add 3D motion without changing the photo's look - takes only 10-30 seconds!

**Steps:**
1. Find **"Image Bypass Switch"** box (blue section)
2. **Uncheck the box** (change "true" to "false")
3. **Click "Queue Prompt"**

**Result:** Your photo stays normal but gets 3D parallax motion - and it's MUCH faster!

---

### 📐 **Task 4: Change Screen Size**

**What you want:** Make video for your phone, TV, or different monitor

**Steps:**
1. Find **"Image Crop to Aspect Ratio"** box (blue section)
2. **Click the dropdown** and pick:
   - **16:9** for TV (1920 × 1080)
   - **16:10** for MacBook (1920 × 1200)
   - **9:16** for phone vertical (1080 × 1920)
3. **Also change** width and height to match
4. **Find "Gaussian Splat Renderer"** box (green section)
5. **Change width and height** there too (must match!)
6. **Click "Queue Prompt"**

**Example for regular TV:**
- Crop box: 16:9, width: 1920, height: 1080
- Renderer box: width: 1920, height: 1080

---

### 🎬 **Task 5: Make a Longer Video**

**What you want:** 20 seconds instead of 10 seconds

**Steps:**
1. Find **"Parallax Camera Path"** box (purple section)
2. Look at **"total_frames"** (default is 300)
3. **Change it to 600** (for 20 seconds)
   - Formula: seconds × 30 = frames
   - 20 seconds × 30 = 600 frames
   - 30 seconds × 30 = 900 frames
4. **Click "Queue Prompt"**

**Note:** Longer videos take more time to process and create bigger files!

---

### 🎭 **Task 6: Use Your Own Custom Style**

**What you want:** Add your own creative instructions (not just presets)

**Steps:**
1. Find **"Qwen Image Edit"** box (blue section)
2. Look for the **"Custom Prompt"** field (second line, usually empty)
3. **Type your own instructions**, like:
   - "add rain and dark clouds"
   - "make it look spooky and haunted"
   - "add fireflies at night"
   - "make it look like a Renaissance painting"
   - "add northern lights in the sky"
4. **Leave the preset as is** (it works with your custom text)
5. **Click "Queue Prompt"**

**Be creative!** The AI understands natural language.

---

### 💾 **Task 7: Name Your Video**

**What you want:** Give your video a specific name instead of "parallax_output"

**Steps:**
1. Find **"Save Video"** box (green section, far right)
2. Look at **"filename_prefix"** (says "parallax_output")
3. **Click and type a new name**, like:
   - "vacation_beach_2025"
   - "grandmas_birthday"
   - "mountain_sunset"
   - "my_dog_max"
4. **Use underscores instead of spaces**
5. **Click "Queue Prompt"**

**Result:** Your video will be named "vacation_beach_2025.mp4" instead of "parallax_output.mp4"

---

### 🔄 **Task 8: Process Multiple Photos**

**What you want:** Make videos of several photos in a row

**Steps:**
1. **Make your first video** (follow the basic steps)
2. **Wait for it to finish**
3. **Click "Load Image"** box again
4. **Choose a different photo**
5. **Click "Queue Prompt"** again

**Time savings:** After the first photo (which takes 1-3 hours on the first ever run), each additional photo only takes 10-30 seconds because the AI "brain" stays loaded!

**Pro tip:** Change the filename_prefix each time so videos don't overwrite each other!

---

## Troubleshooting

### ❌ "Nothing is happening when I click Queue Prompt!"

**Check these things:**

1. **Is the terminal window still open?**
   - Look for a black window with scrolling text
   - If it's closed, restart Parallax Studio from the desktop shortcut

2. **Did you click the right button?**
   - Look for "Queue Prompt" on the RIGHT sidebar
   - It's a button, not a box in the main area

3. **Is there an error message?**
   - Look in the terminal window for red text
   - Read the next sections for specific errors

---

### ❌ "Error: CUDA out of memory"

**What this means:** Your computer's graphics card doesn't have enough memory.

**Solutions (try in order):**

**Solution 1: Turn off the art effect (fastest fix!)**
1. Find **"Image Bypass Switch"** box
2. Change "true" to "false"
3. Try again
- This uses MUCH less memory (47GB → 5GB)

**Solution 2: Close other programs**
1. Close your web browser (especially Chrome)
2. Close any games
3. Close other programs you're not using
4. Try again

**Solution 3: Make the video smaller**
1. Find **"Image Crop to Aspect Ratio"** box
2. Change to smaller numbers:
   - Width: 1920 (instead of 5120)
   - Height: 1080 (instead of 1440)
3. Find **"Gaussian Splat Renderer"** box
4. Change width and height to match
5. Try again

---

### ❌ "First time is taking FOREVER!"

**What this means:** The computer is downloading the 45-50GB AI "brain"

**This is NORMAL!** Here's what to expect:

| Your Internet Speed | How Long It Takes |
|---------------------|-------------------|
| Fast (100+ Mbps) | 1 hour |
| Medium (50 Mbps) | 2 hours |
| Slow (25 Mbps) | 3-4 hours |

**What you'll see:**
- Progress bars showing percentages
- Text like "Downloading model..."
- Lots of file names scrolling

**What to do:**
- **Be patient!** This only happens the FIRST TIME EVER
- Let your computer run - don't turn it off
- Maybe go watch a movie or take a nap 😊
- After this first time, videos take only 10-30 seconds!

**Check progress:**
- Look at the percentages
- If they're going up, it's working!

---

### ❌ "Can't find my video!"

**Where to look:**

1. **Open File Explorer** (the folder icon on your taskbar)
2. **Copy and paste this into the address bar:**
```
   C:\Users\
```
3. **Click on YOUR username folder**
4. **Open these folders in order:**
   - ParallaxStudio-ComfyUI
   - ComfyUI
   - output
5. **Look for:** parallax_output.mp4

**Still can't find it?**
- Check the terminal window for text saying "Saved to: [path]"
- The path tells you exactly where it is

---

### ❌ "My photo looks weird or cut off!"

**What happened:** The crop setting cut off important parts

**How to fix:**
1. Find **"Image Crop to Aspect Ratio"** box
2. Look at the **"crop_position"** setting
3. Try changing it:
   - "center" = keeps the middle
   - "top" = keeps the top part
   - "bottom" = keeps the bottom part

**Or:** Pick a different aspect ratio that's closer to your photo's original shape

---

### ❌ "The art effect looks bad!"

**What to try:**

**Fix 1: Try different settings**
1. Find **"Qwen Image Edit"** box
2. Change **steps** to 75 (higher = better quality)
3. Change **cfg_scale** to 5.0 (higher = stronger effect)
4. Try again

**Fix 2: Try a different style**
- Some photos look better with certain styles
- Try 3-4 different style presets

**Fix 3: Turn off the art effect**
- Maybe your photo already looks perfect!
- Set bypass switch to "false"

---

### ❌ "Video is choppy or not smooth"

**What to try:**

**Fix 1: Lower the amplitude**
1. Find **"Parallax Camera Path"** box
2. Change **amplitude** to a smaller number (like 0.10)
3. Too much movement can look choppy

**Fix 2: Use different easing**
1. In same box, find **easing**
2. Change to "sinusoidal" (smoothest option)

**Fix 3: Increase fps**
1. Change **fps** from 30 to 60
2. This makes motion smoother but doubles the rendering time

---

### ❌ "Program won't start!"

**What to try:**

1. **Restart your computer** (seriously, this fixes a lot!)

2. **Try the desktop shortcut again**
   - Look for "Parallax Studio (ComfyUI)" on your desktop
   - Double-click it

3. **Check if another program is using port 8188**
   - Close any web servers or other programs that might be running

4. **Reinstall**
   - Run the installer again (install_comfyui.bat)
   - Choose "repair" if asked

---

## Tips for Best Results

### 📷 **Tip 1: Pick Good Photos**

**Photos that work GREAT:**
- ✅ Landscapes with mountains, trees, or buildings
- ✅ Portraits with blurred backgrounds
- ✅ Photos with clear "layers" (things in front, things in back)
- ✅ Architecture (buildings, bridges, structures)
- ✅ Nature scenes (forests, beaches, gardens)

**Photos that DON'T work well:**
- ❌ Solid colored walls (no depth)
- ❌ Very blurry photos
- ❌ Extreme close-ups (too close to show depth)
- ❌ Black and white photos (can work, but harder)

**Why?** The AI needs to see what's close and what's far to make the 3D effect!

---

### 🎨 **Tip 2: Match Styles to Photos**

**Good combinations:**

| Your Photo | Try This Style |
|------------|----------------|
| Nature/landscapes | Watercolor, Impressionist, Golden Hour |
| City/urban | Cyberpunk, Noir, Vintage Film |
| People/portraits | Studio Ghibli, Oil Painting |
| Spooky/mysterious | Noir, Add Fog, (custom: "dark and mysterious") |
| Happy/bright | Golden Hour, Impressionist |

---

### 🎬 **Tip 3: Match Movement to Photo**

**Good combinations:**

| Your Photo | Try This Movement |
|------------|-------------------|
| Wide landscape | horizontal_oscillation |
| Tall building | vertical_oscillation |
| Person's face (close-up) | circular |
| Architecture (to show depth) | push_pull |
| Action/exciting scene | figure_eight |

---

### ⚡ **Tip 4: Test First, Then Go High Quality**

**Smart workflow:**

1. **First test run:**
   - Set "steps" to 30 (faster)
   - Use smaller resolution (1920×1080)
   - Make sure everything works!

2. **Final production run:**
   - Set "steps" to 50 or 75 (better quality)
   - Use full resolution (5120×1440)
   - Now you know it'll work!

**Why?** Testing at low quality is MUCH faster - if something's wrong, you find out in 30 seconds instead of 3 minutes!

---

### 💡 **Tip 5: Start Simple**

**For your first few videos:**

1. **Leave most settings at default**
2. **Only change these:**
   - Your photo (Load Image)
   - Art style (Qwen Image Edit dropdown)
   - Bypass switch (try ON and OFF)
   - Video filename (Save Video)

3. **After you're comfortable, experiment with:**
   - Camera movements
   - Custom prompts
   - Amplitude (motion amount)
   - Video length

**Remember:** The default settings are already really good!

---

### 🎯 **Tip 6: Save Your Favorite Settings**

**If you find settings you love:**

1. **Make your video with those settings**
2. **Click "Save" in the top menu**
3. **Give it a name** like "my_favorite_settings.json"
4. **Next time:** Click "Load" and pick that file - all your settings come back!

---

### 📝 **Tip 7: Keep Notes**

**Things worth remembering:**

- Which style presets you liked best
- What amplitude worked well (0.15? 0.20?)
- Which camera movement looked coolest
- What kinds of photos worked best

**Why?** After making 5-10 videos, you'll know exactly what settings you prefer!

---

### 🖼️ **Tip 8: Watch the Preview Image**

That **Preview Image** box in the middle? It shows your photo AFTER cropping and style effects!

**Use it to:**
- Make sure the crop looks good
- See if you like the art style
- Check before waiting for the full video

If the preview looks bad, adjust settings before clicking Queue Prompt!

---

## Quick Reference Sheet

**Print this out and keep it next to your computer!**

---

### 🚀 **Quick Start (5 Steps)**

1. ☐ Load Image → Pick photo
2. ☐ Bypass Switch → Check it's "true"
3. ☐ Crop Ratio → Pick screen size
4. ☐ Camera Path → Pick movement type
5. ☐ Queue Prompt → Click and wait!

---

### 🎨 **Style Presets**

- Studio Ghibli = Anime
- Oil Painting = Brushstrokes
- Watercolor = Dreamy
- Cyberpunk = Neon/Future
- Golden Hour = Warm sunset
- Noir = Black & white
- Add Fog = Misty

---

### 🎥 **Camera Movements**

- horizontal_oscillation = ← →
- vertical_oscillation = ↑ ↓
- circular = ⭕ (orbit)
- push_pull = ⇄ (zoom)
- figure_eight = ∞ (complex)

---

### 📐 **Screen Sizes**

| Screen | Ratio |
|--------|-------|
| TV/Monitor | 16:9 |
| MacBook | 16:10 |
| Phone (vertical) | 9:16 |
| Ultrawide | 21:9 |
| Super wide | 32:9 |

---

### ⚙️ **Key Settings**

| Setting | Good Value |
|---------|-----------|
| steps (quality) | 50 |
| amplitude (motion) | 0.15 |
| total_frames (length) | 300 = 10 sec |
| fps | 30 |
| crf (video quality) | 18 |

---

### 📁 **Where's My Video?**
```
C:\Users\[YOUR_NAME]\
  ParallaxStudio-ComfyUI\
    ComfyUI\
      output\
        parallax_output.mp4
```

---

### ⏱️ **How Long?**

- First EVER run: 1-3 hours (downloading)
- First video each session: 2-3 minutes
- Additional videos: 10-30 seconds
- Without art effect: Even faster!

---

## You Did It! 🎉

**Congratulations!** You now know how to:
- Load photos and turn them into 3D videos
- Change artistic styles
- Control camera movement
- Adjust settings for different screens
- Troubleshoot common problems

**Remember:**
- Be patient with the first run (it's downloading 45-50GB!)
- After that, it's super fast (10-30 seconds)
- Experiment and have fun!
- There's no wrong way to be creative!

**Questions?**
- Read the main README.md for technical details
- Look at the ComfyUI documentation online
- Check the terminal window for error messages

---

## Glossary (Fancy Words Explained)

**Amplitude:** How far something moves (bigger number = more movement)

**Aspect Ratio:** The shape of your screen (width compared to height)

**Bypass:** Skip something (like a detour around traffic)

**Codec:** The format/type of video file (like H.264)

**CRF:** Video quality setting (lower = better)

**Crop:** Cut off edges to fit a certain shape

**FPS:** Frames per second - how smooth video looks

**Gaussian Splat:** Fancy 3D technology using millions of colored points

**Node:** One of the boxes you see (each is a step)

**Parallax:** The 3D effect where close things move more than far things

**Pipeline:** The whole chain of steps from photo to video

**Preset:** A pre-made setting you can just click and use

**Queue Prompt:** The button that starts making your video

**Render:** Creating the final video from all the data

**Resolution:** How detailed the image is (width × height in pixels)

**SHARP:** Apple's 3D AI technology (the name of the model)

**Terminal:** The black window with scrolling text

**VRAM:** Graphics card memory (where the AI "brain" loads)

---

<p align="center">
<b>Have fun making your photos come alive!</b><br>
<i>Remember: The first time takes a while, but after that it's super fast!</i><br><br>
Made with ❤️ for everyone - from age 9 to 99!
</p>
