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
This service will start a mqtt server on port 1883. There 

Cloudflare tunnelts documentation: 
https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/