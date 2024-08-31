# Homeserver for Askov
This project sets up a comprehensive home server solution, integrating various services for smart home management, automation, and secure remote access. The home server is located by my father with the ip address of 192.168.1.35. The full repository for this project can be found at [https://github.com/hansaskov/homeserver](https://github.com/hansaskov/homeserver).

## How do i access the server? 

You can access the files for the homeserver using a terminal or visual studio code (with the "Remote - SSH" extension). A prerequisite for the next step is to ensure you are on the same internet network as the homeserver, you can use the pink command check the connectivity between devices, to get started open up a console/terminal and run the following.
``` bash
ping 192.168.1.35
```

You should hopefully see the some acknolagdements like this
``` bash
ping 192.168.1.35
PING 192.168.1.35 (192.168.1.35) 56(84) bytes of data.
64 bytes from 192.168.1.35: icmp_seq=1 ttl=64 time=3.14 ms
64 bytes from 192.168.1.35: icmp_seq=2 ttl=64 time=2.51 ms
64 bytes from 192.168.1.35: icmp_seq=3 ttl=64 time=3.26 ms
64 bytes from 192.168.1.35: icmp_seq=4 ttl=64 time=2.84 ms
```

If the previous connection succeeded then we can go to the next stop of using ssh.
``` bash
ssh homeserver@192.168.1.35
```
Expect to have an output requesting a password like this.
```bash
(homeserver@192.168.1.35) Password: 
```
You will have to use the password for the homeserver which is the same password as your login to homeassistant. 
The expected output will then be the terminal of the homeserver! Congratulations, you now have access!

But, this is not very user friendly. So let's instead use vscode and Remove ssh to get a graphical user interface. Find and open visual studio code on your computer. Once open, click the `><` symbol at the bottom left of the window and select "connect to host" then choose 192.168.1.35. This will open up a window and ask for a password. You will write the same password as when using ssh. Which is also the same for your homeassistant login.  

For a more detailed guide visit the official documentation: https://code.visualstudio.com/docs/remote/ssh#_connect-to-a-remote-host

## Introduction

The following will be an explanation of the different services run on the home server, but before that let's give a small introduction for how these services are run. All services are run in docker containers. A docker container is essentially an isolated virtual machine where some program is allowed to live and do its thing. This program will usually have a port like 1880 available for other services or users to interact with it. This port is however not accessible on the host system (the pc) because all docker images are run with an isolated docker network. You can see a docker network like a normal lan network, where many docker containers in a docker network is equivalent to many gaming pcs hooked together in a lan setup.

So, since the docker network is not accessible by default, we will have to specify which ports we want to expose to our host pc. This will usually be done with a string in the following format "1880:1880", which says "Point port 1880 inside of the container to port 1880 on the host system". You the user will then be able to access the program running inside the container by visiting the site at http://192.168.1.35:1880. Where "192.168.1.35" describes the static ip set for the home server and 1880 describes the port Node-RED exposes to host system.

To manage all of these docker containers we will use a docker compose file for describing how to run the docker containers. I won't go into all the details as it is quite extensive, so let's instead look at an example of the Node-RED service. Below we have a valid [docker compose file](compose.yaml) for creating a Node-RED service.
```yaml
services:
  nodered:
    image: nodered/node-red
    restart: unless-stopped
    ports:
      - "1880:1880"
    volumes:
      - "./nodered/data:/data"
    depends_on:
      - mosquitto
```

In this example, we're setting up a Node-RED service. The 'image' part tells Docker which container image to use, in this case the official Node-RED image. 'restart: unless-stopped' means the container will always restart unless you manually stop it. The 'ports' section is where we specify which ports to expose, just like we talked about earlier. Here, we're exposing port 1880, which is the default port for Node-RED's web interface.

The 'volumes' part is a bit like connecting an external hard drive to your container. It lets the container access a folder on your actual computer. Here, we're connecting a local folder "./nodered/data" to the "/data" folder inside the container. This way, even if you stop or delete the container, your Node-RED settings will still be there when you start it up again.

This is just the simplest example, you can find 3 more services in the compose.yaml, which i encourage you too look at as it is the backbone of the homeserver. 

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

## Common commands

Download the code with git: 

```bash
git clone https://github.com/hansaskov/homeserver.git
cd homeserver
```

Start docker Services

```bash
docker compose up -d
```

Stop docker Services

```bash
docker compose down
```