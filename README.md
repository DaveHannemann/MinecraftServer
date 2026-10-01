# Minecraft Server with Docker

## Table of Contents

* [Description](#description)
* [Quickstart](#quickstart)

  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)

  * [Project Structure](#project-structure)
  * [Configuration](#configuration)
  * [Port Configuration](#port-configuration)
  * [Persistent Data](#persistent-data)
  * [Server Memory](#server-memory)
  * [Stopping and Restarting](#stopping-and-restarting)
* [Technologies](#technologies)

## Description

This repository contains a self-hosted Minecraft Java Edition server running in a custom Docker container.

The Docker image is built from an Eclipse Temurin Java 25 base image and uses the official Minecraft server application (`server.jar`). Docker Compose is used to configure and run the Minecraft server, expose the required port, persist server data, and automatically restart the container if it terminates unexpectedly.

The project was created to practice containerization with Docker and Docker Compose without using a pre-built Minecraft Docker image.

## Quickstart

### Prerequisites

Before starting the server, make sure the following software is installed:

* [Docker](https://www.docker.com/)
* Docker Compose (included with current Docker installations)
* Git

The repository also contains the required Minecraft `server.jar`.

### Installation

Clone the repository:

```bash
git clone <YOUR-REPOSITORY-URL>
cd <YOUR-REPOSITORY-DIRECTORY>
```

Build and start the Minecraft server:

```bash
docker compose up --build
```

On the first start, Minecraft creates the required server files inside the `local_data` directory.

The Minecraft EULA must be accepted before the server can start. Open:

```text
local_data/eula.txt
```

and change:

```text
eula=false
```

to:

```text
eula=true
```

Start the server again:

```bash
docker compose up
```

The Minecraft server is then available on port `8888` of the Docker host.

For a local installation, connect with:

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
├── server/
│   └── server.jar
├── local_data/
└── README.md
```

* `Dockerfile` defines the custom Minecraft Docker image.
* `docker-compose.yaml` defines and configures the `mc-server` service.
* `server/server.jar` contains the Minecraft server application.
* `local_data/` contains persistent Minecraft server data and is not committed to Git.
* `README.md` contains the project documentation.

### Configuration

The Minecraft server is configured through `docker-compose.yaml`.

The current environment configuration contains the server memory setting:

```yaml
environment:
  MEMORY: "4G"
```

The `MEMORY` variable controls the amount of Java heap memory allocated to the Minecraft server.

The default value is `4G`. If a different amount of memory is required, the value can be changed, for example:

```yaml
environment:
  MEMORY: "2G"
```

or:

```yaml
environment:
  MEMORY: "6G"
```

The configured value is used for both the initial and maximum Java heap size.

> Make sure the Docker host has enough available memory for the configured value.

### Port Configuration

The Docker Compose configuration maps port `8888` on the host to the default Minecraft server port `25565` inside the container:

```yaml
ports:
  - "8888:25565"
```

The first value is the externally accessible host port. The second value is the port used by the Minecraft server inside the container.

For example, changing:

```yaml
ports:
  - "8888:25565"
```

to:

```yaml
ports:
  - "25565:25565"
```

would make the server accessible through port `25565` on the host instead.

### Persistent Data

Minecraft server data is stored using a bind mount:

```yaml
volumes:
  - ./local_data:/minecraft
```

This ensures that the Minecraft world, server configuration, logs, and other generated data are stored on the host filesystem rather than only inside the container.

The data therefore remains available when the container is recreated.

The `local_data` directory should not be committed to the Git repository because it contains generated runtime data and the Minecraft world.

### Server Memory

The Docker Compose configuration passes the memory setting to the Minecraft server.

The Minecraft server is started with:

```text
-Xmx4G
-Xms4G
```

when the default `MEMORY=4G` configuration is used.

* `-Xmx` defines the maximum Java heap size.
* `-Xms` defines the initial Java heap size.

The value can be adjusted through the `MEMORY` environment variable as described above.

### Stopping and Restarting

To stop the server:

```bash
docker compose down
```

To start the existing container again:

```bash
docker compose up
```

To rebuild the Docker image after changing the `Dockerfile`:

```bash
docker compose up --build
```

The server uses:

```yaml
restart: unless-stopped
```

This causes Docker to restart the container if the Minecraft process terminates unexpectedly.

The persistent data in `local_data` is not removed when the container is stopped or recreated.

## Technologies

* Docker
* Docker Compose
* Eclipse Temurin 25
* Java 25
* Minecraft Java Edition
* Minecraft Server 26.3
* Git / GitHub
