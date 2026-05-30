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
    curl -fsSL https://ollama.com/install.sh | sh

# Ensure UV is in the path for the dev user
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
RUN useradd -m -s /bin/bash ${USERNAME} 
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV DISPLAY=:0
# CMD ["/bin/bash"]
ENTRYPOINT ["ollama", "serve"]
