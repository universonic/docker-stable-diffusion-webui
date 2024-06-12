FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as minimal

COPY entrypoint.sh /app/entrypoint.sh

RUN apt update && \
    apt install -y python3 python3-pip python3-venv git wget libgl1-mesa-dev libglib2.0-0 libsm6 libxrender1 libxext6 libgoogle-perftools4 libtcmalloc-minimal4 libcusparse11 xdg-utils bc aria2 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 sdgroup && \
    useradd -m -s /bin/bash -u 1000 -g 1000 --home /app sduser && \
    ln -s /app /home/sduser && \
    chown -R sduser:sdgroup /app && \
    chmod +x /app/entrypoint.sh

USER sduser
WORKDIR /app

RUN git clone -b master https://github.com/AUTOMATIC1111/stable-diffusion-webui.git stable-diffusion-webui && \
    cd stable-diffusion-webui && \
    ./webui.sh -h

WORKDIR /app/stable-diffusion-webui
VOLUME /app/stable-diffusion-webui/extensions
VOLUME /app/stable-diffusion-webui/textual_inversion_templates
VOLUME /app/stable-diffusion-webui/embeddings
VOLUME /app/stable-diffusion-webui/inputs
VOLUME /app/stable-diffusion-webui/models
VOLUME /app/stable-diffusion-webui/outputs
VOLUME /app/stable-diffusion-webui/localizations

EXPOSE 8080

ENV LD_PRELOAD=/usr/local/cuda-12.1/targets/x86_64-linux/lib/libcusparse.so.12
ENV PYTORCH_CUDA_ALLOC_CONF=garbage_collection_threshold:0.9,max_split_size_mb:512

ENTRYPOINT ["/app/entrypoint.sh", "--update-check", "--xformers", "--listen", "--port", "8080"]


FROM minimal as full

RUN cd /app/stable-diffusion-webui && \
    touch install.log && \
    timeout 2h bash -c "./webui.sh --skip-torch-cuda-test --no-download-sd-model --exit"
