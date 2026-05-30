# Containerized VS Code Development Environment

## Build the Containerized Workspace image

```sh
podman build -t my-dev-image:dev -f workspace.dockerfile .
```

## Run the Containerized Workspace

Before starting the container, I suggest to:
- create a directory to mount as HOME in the container (e.g., dev-env-home)
- create a volume to persist storage over different runs (`podman volume create dev-env-data`)

Both are optional, not functionally needed. If you don't use them, update the 

Before starting the container, run `xhost +local:docker` which will allow the apps from inside the container to launch GUI.

To start the containerized development environment, use the following command:

```sh
podman run -it --rm \
    --name my-dev-container \
    --net=host \
    --env="DISPLAY" \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    --ipc=host \                          # optional: needed on some distros (e.g. Fedora) for MIT-SHM; not needed on SteamOS
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v ./dev-env-home:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects:Z \
    my-dev-image:dev
```
The container's `/bin/bash` shell will start.

> **Note:** The Xauthority file must be mounted outside of the home directory (`/tmp/.Xauthority`)
> because the home directory bind-mount (`/home/dev`) would shadow anything mounted inside it.

### Launch VS Code
Run in the bash shell of the container:
```sh
code --no-sandbox --disable-dev-shm-usage
```

## Aliases for quicker launch

Add the following aliases to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):

```sh
export DEV_CONTAINER_HOME="$HOME/dev-env-home"
alias start-workspace='podman run -it --rm \
    --name my-dev-container \
    --net=host \
    --ipc=host \
    --env="DISPLAY" \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects \
    my-dev-image:dev'

# Alias to stop the container
alias stop-workspace='podman stop my-dev-container'

# Alias to launch the containerized VS Code
alias launch-vscode='podman run -it -d --rm \
    --name my-dev-container \
    --net=host \
    --ipc=host \
    --env="DISPLAY" \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects \
    my-dev-image:dev && podman exec -it my-dev-container code --no-sandbox --disable-dev-shm-usage'

alias resume-vscode='podman exec -it my-dev-container code --no-sandbox --disable-dev-shm-usage'
```

After adding the aliases, reload your shell configuration file:

```sh
source ~/.bashrc  # or source ~/.zshrc
```

Now you can use:
- `start-workspace` to start the container.
- `launch-vscode` to launch VS code from the containerized env.
- `stop-workspace` to stop the container.
- `resume-vscode` to resume the VS code session after you closed it. It assumes the workspace container is still running
