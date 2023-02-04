# Stable Diffusion web UI
A browser interface based on Gradio library for Stable Diffusion.

## Usage

Basic example:
```
docker run --gpus all --restart unless-stopped -p 8080:8080 --name stable-diffusion-webui -d universonic/stable-diffusion-webui
```

### Where to Store Data

It is recommended to create a data directory on the host system (outside the container) and mount this to a directory visible from inside the container. This places the data files (including: extensions, models, outputs, etc.) in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly. 

We will simply show the basic procedure here:
1. Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.
2. Start your `stable-diffusion-webui` container like this:
```
docker run --gpus all --restart unless-stopped -p 8080:8080 -v /my/own/datadir/extensions:/app/stable-diffusion-webui/extensions -v /my/own/datadir/models:/app/stable-diffusion-webui/models -v /my/own/datadir/outputs:/app/stable-diffusion-webui/outputs -v /my/own/datadir/localizations:/app/stable-diffusion-webui/localizations --name stable-diffusion-webui -d universonic/stable-diffusion-webui
```
3. Troubleshooting with the following command if you encountered problems:
```
docker logs -f stable-diffusion-webui
```

Important note: `stable-diffusion-webui` will not successfully start and keep restarting if you have no Stable Diffusion model files available in the model directory. e.g. `/my/own/datadir/models/Stable-diffusion`. Put checkpoint and vae file in that directory, wait the server to start and enjoy yourself now.

Follow the [official instructions](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki) if you have further questions.
