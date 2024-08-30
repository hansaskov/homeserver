# Homeserver for Askov. 
You can find the full repository for this project under https://github.com/hansaskov/homeserver. 

Here you can copy the files to you computer using git clone
``` bash
git clone https://github.com/hansaskov/homeserver.git
```

## Quickstart
How to start services. 

``` bash
docker compose up -d

```

How to see the running containers: 
``` bash
docker container list
```

How to stop services
``` bash
docker compose down
```

## Description

This project is structured into three components. Those being homeassistant, mosquitto and cloudflare tunnels.

1. Homeassistant
This is the main purpose of this application. It will allow you to add smart home devices into a singular place. You can see and edit the configuration files of homeassistant under the /hommasistant/config folder. Which you will be told to do by some tutorials. 
2. Mosquitto
This service will start a mqtt server on port 1883. This allows mqtt client to speak to a centraliced broker for cross platform decoupled communication. 
3. Cloudflare tunnels or cloudflared is a service which allows you to access these services securely from a registered domain. For testing purposes you can visit home.hjemmet.net to visit the homeassistant web page. Cloudflare tunnelts documentation: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/

