# ComfyUI serverless worker with SDXL models + proper inpaint tooling baked in.
FROM runpod/worker-comfyui:5.8.5-base

# --- checkpoints ---
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

# --- controlnet aux preprocessors ---
RUN git clone --depth 1 https://github.com/Fannovel16/comfyui_controlnet_aux \
      /comfyui/custom_nodes/comfyui_controlnet_aux && \
    pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui_controlnet_aux/requirements.txt

# --- Acly inpaint nodes (Fooocus inpaint patch — makes a regular checkpoint inpaint cleanly) ---
RUN git clone --depth 1 https://github.com/Acly/comfyui-inpaint-nodes \
      /comfyui/custom_nodes/comfyui-inpaint-nodes && \
    (pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui-inpaint-nodes/requirements.txt 2>/dev/null || true)

# --- Fooocus inpaint patch models ---
RUN mkdir -p /comfyui/models/inpaint && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/lllyasviel/fooocus_inpaint/resolve/main/fooocus_inpaint_head.pth" \
      -O /comfyui/models/inpaint/fooocus_inpaint_head.pth && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://huggingface.co/lllyasviel/fooocus_inpaint/resolve/main/inpaint_v26.fooocus.patch" \
      -O /comfyui/models/inpaint/inpaint_v26.fooocus.patch

# --- Undress LoRA (Pony) — purpose-trained clothed->nude, trigger word "undressing" ---
RUN mkdir -p /comfyui/models/loras && \
    wget --progress=dot:giga --timeout=300 --tries=3 \
      "https://civitai.com/api/download/models/565222" \
      -O /comfyui/models/loras/undressing-PN.safetensors
