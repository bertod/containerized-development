FROM fedora:45

ARG USERNAME=dev

ENV UV_INSTALL_DIR="/usr/local/bin"

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
    tmux \
    gcc \
    && dnf clean all

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
    dnf install -y code && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv python pin 3.12

# set HOME here to install opencode in user space
ENV HOME=/home/${USERNAME}
RUN curl -fsSL https://opencode.ai/v2/install | bash

RUN useradd -m -s /bin/bash ${USERNAME}
RUN chown -R ${USERNAME}:${USERNAME} ${HOME} && chmod 755 ${HOME}
USER ${USERNAME}
ENV PATH="/home/${USERNAME}/.local/bin:/usr/local/bin/:${HOME}/.opencode/bin:${PATH}"

WORKDIR /home/${USERNAME}
ENV DISPLAY=:0
CMD ["/bin/bash"]
