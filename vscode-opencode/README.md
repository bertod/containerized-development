# Containerized VS Code Development Environment + OpenCode

## Build the Containerized Workspace image

```sh
podman build -t my-dev-image:dev -f workspace.dockerfile .
```

## Run the Containerized Workspace

Before starting the container, I suggest to:
- create a directory to mount as HOME in the container (e.g., dev-env-home)
- create a volume to persist storage over different runs (`podman volume create dev-env-data`)
- IF you use Anthropic via Google Vertex:
    - ensure you're logged in on the host
    - copy your gcloud credentials file to another path and give 650 permissions: 
```sh
cp ${HOME}/.config/gcloud/application_default_credentials.json /tmp/
chmod 640 /tmp/application_default_credentials
```

Before running any GUI app in the container, run `xhost local:docker` on the host to allow the container to spawn the GUIs.

To start the containerized development environment, use the following command:

```sh
podman run -it --rm \
    --name opencode \
    --net=host \
    --env="DISPLAY" \
    --userns=keep-id \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    --ipc=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects:Z \
    -v /tmp/application_default_credentials.json:/home/dev/.config/gcloud/application_default_credentials.json:Z \
    --env-file .auth-env \ # contains the Vertex env variable and anyother env variable you need for your scope
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
### Launch OpenCode
```sh
opencode
```

## Aliases for quicker launch

Add the following aliases to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):

```sh
export DEV_CONTAINER_HOME="$HOME/dev-env-home"
export VERTEX_ENV_FILE="$HOME/.vertex-auth-env"
alias opencode-workspace='podman run -it --rm \
    --name opencode \
    --net=host \
    --env="DISPLAY" \
    --userns=keep-id \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    --ipc=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects:Z \
    -v /tmp/application_default_credentials.json:/home/dev/.config/gcloud/application_default_credentials.json:Z \
    --env-file ${VERTEX_ENV_FILE} \
    localhost/opencode'
```

# Alias to stop the container
```sh
alias stop-workspace='podman stop opencode'
```

# Aliases to launch the containerized Applications
```sh
alias launch-vscode='podman run -it --rm \
    --name opencode \
    --net=host \
    --env="DISPLAY" \
    --userns=keep-id \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    --ipc=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects:Z \
    -v /tmp/application_default_credentials.json:/home/dev/.config/gcloud/application_default_credentials.json:Z \
    --env-file ${VERTEX_ENV_FILE} \
    localhost/opencode && podman exec -it opencode code --no-sandbox --disable-dev-shm-usage'

alias resume-vscode='podman exec -it opencode code --no-sandbox --disable-dev-shm-usage'

alias launch-opencode='podman run -it --rm \
    --name opencode \
    --net=host \
    --env="DISPLAY" \
    --userns=keep-id \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    --ipc=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v $XAUTHORITY:/tmp/.Xauthority:ro,Z \
    -v $DEV_CONTAINER_HOME:/home/dev:U,Z \
    -v dev-env-data:/home/dev/projects:Z \
    -v /tmp/application_default_credentials.json:/home/dev/.config/gcloud/application_default_credentials.json:Z \
    --env-file ${VERTEX_ENV_FILE} \
    localhost/opencode && podman exec -it opencode opencode'
```

After adding the aliases, reload your shell configuration file:

```sh
source ~/.bashrc  # or source ~/.zshrc
```

Now you can use:
- `opencode-workspace` to start the container.
- `launch-vscode` to launch VS code from the containerized env.
- `launch-opencode` to launch OpenCode from the containerized env.
- `stop-workspace` to stop the container.
- `resume-vscode` to resume the VS code session after you closed it. It assumes the workspace container is still running
