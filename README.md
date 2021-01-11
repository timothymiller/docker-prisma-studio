# 💾 Prisma Studio (for Docker)

Access Prisma Studio through your web browser.

Share multiple database environments' access with colleagues. Deployed via Traefik for global access.

## 📊 Stats

| Size  | Downloads | Discord |
| ------------- | ------------- | ------------- |
| [![prisma-studio docker image size](https://img.shields.io/docker/image-size/timothyjmiller/prisma-studio?style=flat-square)](https://hub.docker.com/r/timothyjmiller/prisma-studio "prisma-studio docker image size")  | [![Total DockerHub pulls](https://img.shields.io/docker/pulls/timothyjmiller/prisma-studio?style=flat-square)](https://hub.docker.com/r/timothyjmiller/prisma-studio "Total DockerHub pulls")  | [![Official Discord Server](https://img.shields.io/discord/788313754181173259?style=flat-square)](https://discord.gg/gtF4AX9UGA "Official Discord Server")

## ⁉️ How Private & Secure?

1. 🪨 Stable Debian-slim base image
2. 🔒 100% [Docker Bench Security](https://github.com/docker/docker-bench-security) compliant
3. 👨‍💻 Open source for open audits
4. 📈 Regular updates
5. 0️ Zero extra dependencies

## 🖥️ Supported Architectures

At the time of this writing, @prisma/cli only supports AMD64

ARM64 support will come shortly after Prisma officially supports it.

[Relevant Github Issue](https://github.com/prisma/prisma/issues/861)

## How it Works

A docker container with the latest LTS of NodeJS and the ```@prisma/cli``` module introspects your postgres database to auto-generate a prisma schema in the form ```schema.prisma```.

Prisma Studio is then made available at the port specified to display your data source.

## 👨‍💻 Deploying

### ⚠️ Prerequisites

#### Traefik v2 network

Setting up an on-premise HTTPS reverse proxy requires knowledge of [Traefik v2](https://doc.traefik.io/traefik/)

For help setting up an on-premise or cloud-agnostic HTTPS reverse proxy for Kubernetes, [email me](mailto:tim.miller@preparesoftware.com?subject=[GitHub%20Consulting]%20docker-prisma-studio) or [contact me on Discord](https://discord.gg/gtF4AX9UGA)

### 🐋 Docker Compose

Use the included docker-compose.yml file as a base for your installation.

```dockerfile
version: '3.7'
services:
  prisma-studio:
    container_name: prisma-studio
    image: timothyjmiller/prisma-studio:latest
    restart: unless-stopped
    environment:
      POSTGRES_URL: "postgresql://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_IP_ADDRESS:$POSTGRES_DEFAULT_PORT/$POSTGRES_DATABASE"
    ports:
      - ${PRISMA_STUDIO_PORT}:5555/tcp
    networks:
      traefik_proxy:
        ipv4_address: $PRISMA_STUDIO_IP_ADDRESS
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.prisma-studio-rtr.entrypoints=https"
      - "traefik.http.routers.prisma-studio-rtr.tls=true"
      - "traefik.http.routers.prisma-studio-rtr.rule=Host(`prisma-studio-${PROJECT_NAME}-${POSTGRES_DATABASE}.${DOMAIN_NAME}`)"
      - "traefik.http.routers.prisma-studio-rtr.service=prisma-studio-svc"
      - "traefik.http.services.prisma-studio-svc.loadbalancer.server.port=5555"
  postgres:
    container_name: postgres
    image: postgres:latest
    restart: always
    ports:
      - ${POSTGRES_PORT}:5432
    networks:
      traefik_proxy:
        ipv4_address: $POSTGRES_IP_ADDRESS
    volumes:
      - ${POSTGRES_PATH}/${PROJECT_NAME}/${POSTGRES_DATABASE}/:/var/lib/postgresql/data
    environment:
      POSTGRES_URL: "postgresql://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_IP_ADDRESS:$POSTGRES_DEFAULT_PORT/$POSTGRES_DATABASE"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
networks:
  traefik_proxy:
    external: true
```

## 📁 Environment Variables

### ⚠️ Warning

Make sure you securely generate new passwords for your postgres database for use with Prisma Studio.

1. Create a file named ```.env```

2. Give ```.env``` the following contents:

```bash
PROJECT_NAME=demo-project
POSTGRES_DATABASE=development
POSTGRES_HOST=postgres
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_PORT=5432
PRISMA_STUDIO_PORT=5555
POSTGRES_PATH=/postgres
```

You may have to change the port numbers for ```Postgres``` & ```Prisma Studio``` depending on the availability of your host machine.

## ☁️ Enterprise Deployments

For DevOps help setting up an on-premise or cloud-agnostic environment for software engineers, [email me](mailto:tim.miller@preparesoftware.com?subject=[GitHub%20Consulting]%20docker-prisma-studio) or [contact me on Discord](https://discord.gg/gtF4AX9UGA)

Create three ```.env``` configs

1. development
2. testing
3. production

Each config should have it's own database name (development, testing, and production), port number, plus unique passwords for each environment. Securely store the Postgres database credentials for safe-keeping.

## License

This Template is licensed under the GNU General Public License, version 3 (GPLv3).

## Author

Timothy Miller

[View my GitHub profile 💡](https://github.com/timothymiller)

[View my personal website 💻](https://timknowsbest.com)
