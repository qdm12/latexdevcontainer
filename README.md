# Latex Dev Container

**Ultimate Latex development container for Visual Studio Code**

[![Build status](https://github.com/qdm12/latexdevcontainer/workflows/Buildx%20latest/badge.svg)](https://github.com/qdm12/latexdevcontainer/actions?query=workflow%3A%22Buildx+latest%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/latexdevcontainer.svg)](https://hub.docker.com/r/qmcgaw/latexdevcontainer)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/latexdevcontainer.svg)](https://hub.docker.com/r/qmcgaw/latexdevcontainer)
[![Image size](https://images.microbadger.com/badges/image/qmcgaw/latexdevcontainer.svg)](https://microbadger.com/images/qmcgaw/latexdevcontainer)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/latexdevcontainer.svg)](https://microbadger.com/images/qmcgaw/latexdevcontainer)

[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)
[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/latexdevcontainer.svg)](https://github.com/qdm12/latexdevcontainer/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/latexdevcontainer.svg)](https://github.com/qdm12/latexdevcontainer/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/latexdevcontainer.svg)](https://github.com/qdm12/latexdevcontainer/issues)

## Features

- Fastest way to code LaTex and produce a pdf file when saving your .tex file
- Based on [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer) (Alpine 3.12) with:
    - [texlive](https://www.tug.org/texlive)
    - [chktex](https://www.nongnu.org/chktex)
    - Perl modules for [latexindent](https://github.com/cmhughes/latexindent.pl)
- Compatible with amd64, i686 (32 bit), ARM 64 bit, ARM 32 bit v6 and v7
- Cross platform
    - Easily bind mount your SSH keys to use with **git**
    - Manage your host Docker from within the dev container, more details at [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer#features)
- Extensible with docker-compose.yml

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop) installed and running
    - If you don't use Linux, share the directories `~/.ssh` and the directory of your project with Docker Desktop
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- [VS code](https://code.visualstudio.com/download) installed
- [VS code remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed

## Setup for a project

1. Download this repository and put the `.devcontainer` directory in your project.
   Alternatively, use this shell script from your project path

    ```sh
    # we assume you are in /yourpath/myproject
    mkdir .devcontainer
    cd .devcontainer
    wget -q https://raw.githubusercontent.com/qdm12/latexdevcontainer/master/.devcontainer/devcontainer.json
    wget -q https://raw.githubusercontent.com/qdm12/latexdevcontainer/master/.devcontainer/docker-compose.yml
    ```

1. Open the command palette in Visual Studio Code (CTRL+SHIFT+P) and select `Remote-Containers: Open Folder in Container...` and choose your project directory

## More

### devcontainer.json

- You can change the `"postCreateCommand"` to be relevant to your situation.
- You can change the extensions installed in the Docker image within the `"extensions"` array
- Other Latex settings can be changed or added in the `"settings"` object.

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
        USER root
        apk add curl
        USER vscode
        ```

    1. Modify `.devcontainer/docker-compose.yml` and add `build: .` in the vscode service.
    1. Open the VS code command palette and choose `Remote-Containers: Rebuild container`

- You can bind mount a shell script to `/home/vscode/.welcome.sh` to replace the [current welcome script](shell/.welcome.sh)

## TODOs

- [qmcgaw/basedevcontainer](https://github.com/qdm12/basedevcontainer) todos

## License

This repository is under an [MIT license](https://github.com/qdm12/latexdevcontainer/master/LICENSE) unless indicated otherwise.
