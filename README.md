# Containerized Development Environments

## Goal

This repository provides pre-configured **containerized development environments** to streamline and standardize development workflows. Containerization ensures consistency across different systems, simplifies dependency management, and allows for isolated development environments.

## Available Environments

### 1. **VS Code Development Environment**
A containerized VS Code environment with Python 3.12, `uv`, and essential tools and configurations for general-purpose development.

- **Instructions**: [VS Code Dev Environment](./vscode-python312/README.md)

### 2. **VS Code + Claude Code**
The VS Code environment extended with Claude Code and the Google Cloud CLI, including support for Anthropic via Google Vertex.

- **Instructions**: [VS Code + Claude Code Environment](./vscode-claudecode/README.md)

### 3. **VS Code + OpenCode**
The VS Code environment extended with [OpenCode](https://opencode.ai) for AI-assisted development inside the container.

- **Instructions**: [VS Code + OpenCode Environment](./vscode-opencode/README.md)

### 4. **Ollama Server**
A containerized [Ollama](https://ollama.com) server with an OpenAI-compatible endpoint at `127.0.0.1:11434/v1`, for running local models alongside the development environments.

- **Instructions**: [Ollama Environment](./python312-ollama/README.md)

---

## How to Use

1. **Clone this repository** to your local machine.
2. **Navigate to the desired environment** (e.g., `vscode-python312`, `vscode-claudecode`, `vscode-opencode`, or `python312-ollama`).
3. **Follow the instructions** in the environment-specific `README.md` to set up and run the container.

## Prerequisites

- **Podman** or **Docker** installed on your system.
- Basic familiarity with containerization concepts.