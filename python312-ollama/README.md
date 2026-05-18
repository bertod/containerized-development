# Containerized VS Code Development Environment

## Build the Containerized Workspace image

```sh
podman build -t my-ollama:dev -f workspace.dockerfile .
```
Before starting the container, I suggest to:
- create a volume to persist ollama pulled models (`podman volume create ollama`)

## Start ollama server
```sh
podman run --replace --device /dev/kfd --device /dev/dri --net=host -v dev-ollama:/dev/.ollama -p 11434:11434 -e OLLAMA_VULKAN=1 --name dev-ollama dev-ollama
```
You can add `-d` to run in detach mode.
The server exposes an OpenAI endpoint at `127.0.0.1:11434/v1`

## Pull models
```sh
podman exec -it dev-ollama ollama pull qwen3.5:0.8b
```
## Aliases for quicker launch

Add the following aliases to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`):

```sh
export DEV_CONTAINER_HOME="$HOME/dev-env-home"
alias start-ollama='podman run --replace --device /dev/kfd --device /dev/dri --net=host -v dev-ollama:/dev/.ollama -p 11434:11434 -e OLLAMA_VULKAN=1 --name dev-ollama dev-ollama'

# SO function to pull ollama models
pullmodel() {  podman exec -it dev-ollama ollama pull "$@" ;}

# SO function chat with a model through ollama
chat() {  podman exec -it dev-ollama ollama run "$@" ;}
```

After adding the aliases, reload your shell configuration file:

```sh
source ~/.bashrc  # or source ~/.zshrc
```

Now you can use:
- `start-ollama`
- `pullmodel` 
- `chat`
