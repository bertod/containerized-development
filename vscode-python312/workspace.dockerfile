FROM fedora:45

ARG USERNAME=dev

# Install system dependencies, including 'patch'
RUN dnf update -y && dnf install -y \
    python3.12 \
    python3-pip \
    curl \
    git \
    patch \
    sudo \
    gpg \
    # VS Code GUI dependencies for Fedora
    nss \
    at-spi2-atk \
    libX11-xcb \
    libdrm \
    gtk3 \
    mesa-libgbm \
    alsa-lib \
    libxshmfence \
    libxkbcommon \
    && dnf clean all

# Install VS Code using the RPM repository
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
    dnf install -y code && \
    curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure UV is in the path for the dev user
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
RUN useradd -m -s /bin/bash ${USERNAME} 
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV DISPLAY=:0
CMD ["/bin/bash"]
#ENTRYPOINT ["code", "--no-sandbox", "--wait"]
