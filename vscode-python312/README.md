# Containerized VS Code Development Environment

## Run the Containerized Workspace

Before starting the container, I suggest to:
- create a directory to mount as HOME in the container (e.g., dev-env-home)
- create a volume to persist storage over different runs (`podman volume create dev-env-data`)

Both are optional, not functionally needed. If you don't use them, update the 

To start the containerized development environment, use the following command:

```sh
podman run -it --rm \
    --name my-dev-container \
    --net=host \
    --env="DISPLAY" \
    -v $XAUTHORITY:/home/dev/.Xauthority:ro \
    -v ./dev-env-home:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects:Z \
    my-dev-image:dev
```
The container's `/bin/bash` shell will start.

### Launch VS Code
run `code` in the  bash shell of the container

## Aliases for quicker launch

Add the following aliases to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):

```sh
export DEV_CONTAINER_HOME="$HOME/dev-env-home"
alias start-workspace='podman run -it --rm \
    --name my-dev-container \
    --net=host \
    --env="DISPLAY" \
    -v $XAUTHORITY:/home/dev/.Xauthority:ro \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects \
    my-dev-image:dev'

# Alias to stop the container
alias stop-workspace='podman stop my-dev-container'

# Alias to launch the containerized VS Code
alias launch-vscode='podman run -it -d --rm \
    --name my-dev-container \
    --net=host \
    --env="DISPLAY" \
    -v $XAUTHORITY:/home/dev/.Xauthority:ro \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects \
    my-dev-image:dev && podman exec -it my-dev-container code'
```

After adding the aliases, reload your shell configuration file:

```sh
source ~/.bashrc  # or source ~/.zshrc
```

Now you can use:
- `start-workspace` to start the container.
- `launch-vscode` to launch VS code from the containerized env.
- `stop-workspace` to stop the container.