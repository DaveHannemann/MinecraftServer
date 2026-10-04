# Minecraft Server with Docker

This repository contains a self-hosted Minecraft Java Edition server running in a custom Docker container.

The Docker image is built from an Eclipse Temurin Java 25 base image and uses the official Minecraft server application (`server.jar`). Docker Compose is used to build and run the Minecraft server, configure the server through environment variables, expose the required port, persist server data using a named volume, and automatically restart the container if it terminates unexpectedly.

The project was created to practice containerization with Docker and Docker Compose without using a pre-built Minecraft Docker image.

## Table of Contents

- [Quickstart](#quickstart)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Project Structure](#project-structure)
  - [Configuration](#configuration)
  - [Port Configuration](#port-configuration)
  - [Persistent Data](#persistent-data)
  - [Server Memory](#server-memory)
  - [Stopping and Restarting](#stopping-and-restarting)
- [Technologies](#technologies)

## Quickstart

### Prerequisites

Before starting the server, make sure the following software is installed:

- [Docker](https://www.docker.com/)
- Docker Compose (included with current Docker installations)
- Git

The repository also contains the required Minecraft `server.jar`.

### Installation

Clone the repository:

```bash
git clone https://github.com/DaveHannemann/MinecraftServer.git
cd MinecraftServer
```

Create the environment configuration:

```bash
cp .env.example .env
```

Adjust the values in `.env` according to your requirements.

Make sure that the Minecraft EULA is accepted:

```env
EULA=true
```

Build and start the Minecraft server:

```bash
docker compose up --build -d
```

Check the server logs:

```bash
docker compose logs -f
```

The Minecraft server is then available on the configured host port.

With the default configuration, connect using:

```text
localhost:8888
```

## Usage

### Project Structure

The main project files are organized as follows:

```text
.
├── Dockerfile
├── docker-compose.yaml
├── entrypoint.sh
├── server/
│   └── server.jar
├── .env.example
├── .gitignore
└── README.md
```

- `Dockerfile` defines the custom Minecraft Docker image.
- `docker-compose.yaml` defines and configures the `mc-server` service.
- `entrypoint.sh` prepares the Minecraft server configuration and starts the server.
- `server.jar` contains the official Minecraft server application.
- `.env.example` provides an example configuration for the required environment variables.
- `.gitignore` contains files and directories that should not be committed to Git.
- `README.md` contains the project documentation.

Minecraft server data is stored in a Docker-managed named volume and is therefore not part of the repository.

### Configuration

The Minecraft server is configured through environment variables.

Create the local `.env` file from the provided example:

```bash
cp .env.example .env
```

The available configuration variables include:

```env
MEMORY=2G
EULA=true
WHITE_LIST=false
MAX_PLAYERS=10
DIFFICULTY=normal
GAMEMODE=survival
MOTD=My Minecraft Server
SERVER_PORT=25565
HOST_PORT=8888
```

#### EULA

The Minecraft EULA must be explicitly accepted:

```env
EULA=true
```

If `EULA` is not set to `true`, the entrypoint script stops the container and displays an error message.

#### Whitelist

The whitelist can be enabled or disabled using:

```env
WHITE_LIST=false
```

Set it to `true` if only whitelisted players should be allowed to join.

#### Maximum Players

The maximum number of players can be configured using:

```env
MAX_PLAYERS=10
```

#### Difficulty

Available Minecraft difficulty values are:

```text
peaceful
easy
normal
hard
```

For example:

```env
DIFFICULTY=normal
```

#### Gamemode

Available gamemodes are:

```text
survival
creative
adventure
spectator
```

For example:

```env
GAMEMODE=survival
```

#### MOTD

The server name displayed in the Minecraft server list can be configured using:

```env
MOTD=My Minecraft Server
```

### Port Configuration

The Minecraft server uses two port variables:

```env
SERVER_PORT=25565
HOST_PORT=8888
```

`SERVER_PORT` defines the port used by Minecraft inside the container.

`HOST_PORT` defines the port exposed by Docker on the host.

Docker Compose maps these ports using:

```yaml
ports:
  - "${HOST_PORT}:${SERVER_PORT}"
```

With the default configuration, the mapping is:

```text
8888 → 25565
```

For a local installation, connect to:

```text
localhost:8888
```

### Persistent Data

Minecraft server data is stored in a Docker-managed named volume:

```yaml
volumes:
  - minecraft-data:/minecraft
```

The named volume stores persistent Minecraft data such as:

- Minecraft worlds
- `server.properties`
- `eula.txt`
- server logs
- other generated server data

The data remains available when the container is stopped, restarted, or recreated.

The named volume can be viewed with:

```bash
docker volume ls
```

> Do not use `docker compose down -v` unless the persistent Minecraft data should be deleted. The `-v` option removes the Docker volume and therefore deletes the stored server data.

### Server Memory

The Java heap size is configured through the `MEMORY` environment variable:

```env
MEMORY=2G
```

The entrypoint starts the Minecraft server using:

```text
-Xmx2G
-Xms2G
```

when `MEMORY=2G` is configured.

- `-Xmx` defines the maximum Java heap size.
- `-Xms` defines the initial Java heap size.

The same value is used for both settings.

Make sure the Docker host has enough available memory for the configured value.

### Stopping and Restarting

To stop the server:

```bash
docker compose down
```

To start the server again:

```bash
docker compose up -d
```

To restart the running container:

```bash
docker compose restart
```

To rebuild the Docker image after changing the `Dockerfile` or other build-related files:

```bash
docker compose up --build -d
```

The server uses:

```yaml
restart: unless-stopped
```

This causes Docker to automatically restart the container if the Minecraft process terminates unexpectedly.

The persistent Minecraft data stored in the named volume is not removed when the container is stopped or recreated.

## Technologies

- Docker
- Docker Compose
- Eclipse Temurin 25
- Java 25
- Minecraft Java Edition
- Minecraft Server 26.3
- Shell scripting
- Git / GitHub