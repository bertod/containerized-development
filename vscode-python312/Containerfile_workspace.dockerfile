# Use official Python 3.12 on Debian Bookworm
FROM python:3.12-bookworm

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ARG USERNAME=dev

# Install system dependencies, including 'patch'
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    git \
    patch \
    sudo \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Install VS Code
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && apt-get install -y code && \
    rm microsoft.gpg

# Create a non-root user 'deck' to match SteamOS (prevents permission headaches)
RUN useradd -m -s /bin/bash ${USERNAME} 
#&& \
#    echo "deck ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV DISPLAY=:0
# Set the entry point to bash
CMD ["/bin/bash"]
#ENTRYPOINT ["code", "--no-sandbox", "--wait"]
