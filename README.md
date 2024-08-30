# Homeserver for Askov

This project sets up a comprehensive home server solution, integrating various services for smart home management, automation, and secure remote access. The full repository for this project can be found at [https://github.com/hansaskov/homeserver](https://github.com/hansaskov/homeserver).

## Quick Start

### Download project using git clone

```bash
git clone https://github.com/hansaskov/homeserver.git
cd homeserver
```

### Start Services

```bash
docker compose up -d
```

### Stop Services

```bash
docker compose down
```

## Components

### Home Assistant

[Home Assistant](https://www.home-assistant.io/) is the core of this application, providing a centralized platform for managing smart home devices. Configuration files can be found and edited in the `/homeassistant/config` folder.

### Mosquitto

Mosquitto serves as an MQTT broker, running on port 1883. It facilitates communication between MQTT clients, enabling cross-platform, decoupled messaging for various smart home devices and services.

### Cloudflare Tunnels

Cloudflare Tunnels (cloudflared) provides secure remote access to your services through a registered domain. For testing, you can access the Home Assistant web interface at [home.hjemmet.net](https://home.hjemmet.net) or [localhost:8123](https://localhost:8123)

For more information, refer to the [Cloudflare Tunnels documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/).

### Node-RED

[Node-RED](https://nodered.org/) is a powerful flow-based development tool for visual programming. It allows you to wire together hardware devices, APIs, and online services in a visual flow-based programming interface. In this setup, Node-RED can be used to create complex automations such as with Home Assistant and MQTT.

Node-RED runs on port 1880 and can be accessed here [localhost:1880](https://localhost:1880)