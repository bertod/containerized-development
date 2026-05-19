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
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && \
    tar -xf google-cloud-cli-linux-x86_64.tar.gz && \
    mv google-cloud-sdk /opt/google-cloud-sdk && \
    /opt/google-cloud-sdk/install.sh --quiet && \
    ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    curl -fsSL https://claude.ai/install.sh | bash && \
    ln -s ~/.local/bin/claude /usr/local/bin/claude

# Ensure UV is in the path for the dev user
ENV PATH="/home/${USERNAME}/.local/bin:/usr/local/bin/:${PATH}"
RUN useradd -m -s /bin/bash ${USERNAME}

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown -R ${USERNAME}:0 ${HOME}
    #chmod -R ug+rwx ${HOME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV DISPLAY=:0
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
