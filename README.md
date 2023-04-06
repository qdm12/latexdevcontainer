# Latex Dev Container

**Ultimate Latex development container for Visual Studio Code**

<img height="250" src="https://raw.githubusercontent.com/qdm12/latexdevcontainer/master/title.svg?sanitize=true">

[![Build status](https://github.com/qdm12/latexdevcontainer/workflows/CI/badge.svg)](https://github.com/qdm12/latexdevcontainer/actions?query=workflow%3ACI)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/latexdevcontainer.svg)](https://hub.docker.com/r/qmcgaw/latexdevcontainer)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/latexdevcontainer.svg)](https://hub.docker.com/r/qmcgaw/latexdevcontainer)

[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)
[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/latexdevcontainer.svg)](https://github.com/qdm12/latexdevcontainer/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/latexdevcontainer.svg)](https://github.com/qdm12/latexdevcontainer/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/latexdevcontainer.svg)](https://github.com/qdm12/latexdevcontainer/issues)

## Features

- Fastest way to code LaTex and produce a pdf file when saving your .tex file
- Uses [texlive 2021](https://www.tug.org/texlive/acquire-netinstall.html)
- Based on Debian Bullseye Slim, using [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer)
- Compatible with `amd64` and `aarch64`
- **Two Docker images**:
    - `qmcgaw/latexdevcontainer:latest` (default) which uses the TexLive basic scheme and has an uncompressed image size of 467MB
    - `qmcgaw/latexdevcontainer:latest-full` which uses the TexLive full scheme and has an uncompressed image size of 4.2GB - most packages you would need are already installed.
- Comes with `tlmgr` to install more LaTex packages as needed
- Latex compilation to pdf with [latexmk](https://mg.readthedocs.io/latexmk.html)
- Formatting on save using [latexindent](https://github.com/cmhughes/latexindent.pl)
- Latex linting using [chktex](https://www.nongnu.org/chktex) built from source
- Using the [LaTex-Workshop VScode extension](https://github.com/James-Yu/LaTeX-Workshop)
- Compatible with amd64, ~ARM 64 bit, ARM 32 bit v6 and v7~ (TeXLive not available on ARM, create an issue if you need it)
- Cross platform
    - Easily bind mount your SSH keys to use with **git**
    - Manage your host Docker from within the dev container, more details at [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer#features)
- Extensible with docker-compose.yml
- Minimal uncompressed image size of 467MB

[![Demo](https://i.imgur.com/4jFRIql.gif)](https://github.com/qdm12/latexdevcontainer)

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop) installed and running
    - If you don't use Linux, share the directories `~/.ssh` and the directory of your project with Docker Desktop
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- [VS code](https://code.visualstudio.com/download) installed
- [VS code remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed

## Setup for a project

1. Setup your configuration files
    - With style 💯

        ```sh
        docker run -it --rm -v "/yourrepopath:/repository" qmcgaw/devtainr:v0.4.0 -dev latex -path /repository -name projectname
        ```

        Or use the [built binary](https://github.com/qdm12/devtainr#binary)
    - Or manually: download this repository and put the [.devcontainer](.devcontainer) directory in your project.
1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Remote-Containers: Open Folder in Container...` and choose your project directory

[![Install](https://i.imgur.com/1NJHIbH.gif)](https://github.com/qdm12/latexdevcontainer#setup-for-a-project)

## Install LaTex packages

If you need for example the package `lastpage`, open the integrated terminal in VS Code, select `zsh` and enter:

```sh
tlmgr install lastpage
texhash
```

[![Install packages](https://i.imgur.com/mBM2NYB.gif)](https://github.com/qdm12/latexdevcontainer#install-latex-packages)

## Update the Latex Docker image

1. Pull the docker image

    ```sh
    docker pull qmcgaw/latexdevcontainer
    ```

1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Remote-Containers: Rebuild and Reopen in Container...`. ⚠️ this will erase your container shell history and custom latex packages you added on top of the base image.

## More

### devcontainer.json

- You can change the `"postCreateCommand"` to be relevant to your situation. For example:

    ```json
    "postCreateCommand": "tlmgr install acronym pgf && texhash",
    ```

- You can change the extensions installed in the Docker image within the `"customizations/vscode/extensions"` array
- Other Latex settings can be changed or added in the `"customizations/vscode/settings"` object.

### Development image

- You can build the development image yourself:

    ```sh
    docker build -t qmcgaw/latexdevcontainer -f Dockerfile https://github.com/qdm12/latexdevcontainer.git
    ```

- You can extend the Docker image `qmcgaw/latexdevcontainer` with your own instructions.

    1. Create a file `.devcontainer/Dockerfile` with `FROM qmcgaw/latexdevcontainer`
    1. Append instructions to the Dockerfile created. For example:

        ```Dockerfile
        FROM qmcgaw/latexdevcontainer
        RUN tlmgr install lastpage
        ```

    1. Modify `.devcontainer/docker-compose.yml` and add `build: .` in the vscode service.
    1. Open the VS code command palette and choose `Remote-Containers: Rebuild container`

- You can bind mount a shell script to `/home/vscode/.welcome.sh` to replace the [current welcome script](shell/.welcome.sh)

## TODOs

- [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer) todos

## License

This repository is under an [MIT license](https://github.com/qdm12/latexdevcontainer/master/LICENSE) unless indicated otherwise.
