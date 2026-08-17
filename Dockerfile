FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-dev git curl wget tmux htop \
    libgl1 libglib2.0-0 build-essential \
    && rm -rf /var/lib/apt/lists/*

# Шаг 1: PyTorch из специального индекса (только torch/torchvision/torchaudio)
RUN pip3 install --no-cache-dir --break-system-packages \
    torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu128

# Шаг 2: Остальные пакеты из обычного PyPI
RUN pip3 install --no-cache-dir --break-system-packages \
    numpy pandas scikit-learn matplotlib seaborn \
    jupyterlab ipywidgets \
    wandb mlflow \
    hydra-core omegaconf

WORKDIR /workspace

EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", \
     "--no-browser", "--allow-root", "--NotebookApp.token=''"]
