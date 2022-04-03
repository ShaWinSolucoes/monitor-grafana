# Monitor

Monitor tools to ATC network

# Prerequisites

- Docker
- Docker Compose

# Installing

### Docker

Get docker and install it:

```
curl -fsSL https://get.docker.com | bash
```

Add your user to group:

```
sudo usermod -aG docker $USER
```

Test the instalation:

```
docker version
```

### Docker Compose

Run this command to download the docker compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Apply permissions to the binary

```
sudo chmod +x /usr/local/bin/docker-compose
```

Test the instalation:

```
docker-compose version
```

# Development

### Start

Create .env file with the environment variables as the template:

```
PORT=3002
```

Where:

- **PORT=**: Port to up grafana

Up the containers running:

```
./run.sh up
```

# Restart

If you want to restart the application preserving the data, run:

```
./run.sh restart
```
