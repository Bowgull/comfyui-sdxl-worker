# ComfyUI serverless worker with SDXL models baked in (fast cold starts —
# models load from local disk instead of a network volume).
FROM runpod/worker-comfyui:5.8.5-base

# Each model in its own layer (GHCR caps layers at 10GB).
RUN wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/cyberdelia/CyberRealisticPony/resolve/main/CyberRealisticPony_V18.0_F16.safetensors" \
      -O /comfyui/models/checkpoints/cyberrealisticPonyV18.safetensors

RUN wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/SG161222/RealVisXL_V5.0/resolve/main/RealVisXL_V5.0_fp16.safetensors" \
      -O /comfyui/models/checkpoints/realvisxlV5.safetensors

RUN mkdir -p /comfyui/models/controlnet && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/diffusers/controlnet-depth-sdxl-1.0/resolve/main/diffusion_pytorch_model.fp16.safetensors" \
      -O /comfyui/models/controlnet/controlnet-depth-sdxl-1.0.safetensors

RUN git clone --depth 1 https://github.com/Fannovel16/comfyui_controlnet_aux \
      /comfyui/custom_nodes/comfyui_controlnet_aux && \
    pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui_controlnet_aux/requirements.txt
