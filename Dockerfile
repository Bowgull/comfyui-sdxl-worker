# Flux Kontext worker — instruction-based image editing ("remove the clothing").
FROM runpod/worker-comfyui:5.8.5-base

# Kontext diffusion model (fp8)
RUN mkdir -p /comfyui/models/diffusion_models && \
    wget --progress=dot:giga --timeout=600 --tries=3 \
      "https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors" \
      -O /comfyui/models/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors

# Text encoders
RUN mkdir -p /comfyui/models/text_encoders && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors" \
      -O /comfyui/models/text_encoders/clip_l.safetensors && \
    wget --progress=dot:giga --timeout=600 --tries=3 \
      "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors" \
      -O /comfyui/models/text_encoders/t5xxl_fp8_e4m3fn.safetensors

# Flux VAE
RUN mkdir -p /comfyui/models/vae && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/sirorable/flux-ae-vae/resolve/main/ae.safetensors" \
      -O /comfyui/models/vae/ae.safetensors

# Undress LoRA (Flux variant) — trigger word "undressing"
RUN mkdir -p /comfyui/models/loras && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/Muapi/undressing-sd1-xl-pony-flux/resolve/main/undressing-sd1-xl-pony-flux.safetensors" \
      -O /comfyui/models/loras/undressing-flux.safetensors
