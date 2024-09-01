# Homeserver for Askov

This project sets up a comprehensive home server solution, integrating various services for smart home management, automation, and secure remote access. The home server is located at my father's place with the IP address `192.168.1.35`. The full repository for this project can be found at [GitHub: hansaskov/homeserver](https://github.com/hansaskov/homeserver).

### Services

- **[Home Assistant](http://192.168.1.35:8123)**: Manage and control smart home devices.
- **[Node-RED](http://192.168.1.35:1880)**: Visual tool for wiring together devices, APIs, and online services.

## Prerequisites

1. **[Visual Studio Code](https://code.visualstudio.com/Download)**
2. **[Remote - SSH Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)**
3. **[Nix IDE Extension (Optional)](https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide)**

## How do I access the server?

You can access the files on the homeserver using a terminal/commandprompt or Visual Studio Code (with the "Remote - SSH" extension). A prerequisite for the next step is ensuring that you are on the same internet network as the homeserver. You can use the `ping` command to check the connectivity between devices on the same network. To get started, open a console/terminal and run the following:

```bash
ping 192.168.1.35
```

You should hopefully see some acknowledgments like this:

```bash
ping 192.168.1.35
PING 192.168.1.35 (192.168.1.35) 56(84) bytes of data.
64 bytes from 192.168.1.35: icmp_seq=1 ttl=64 time=3.14 ms
64 bytes from 192.168.1.35: icmp_seq=2 ttl=64 time=2.51 ms
64 bytes from 192.168.1.35: icmp_seq=3 ttl=64 time=3.26 ms
64 bytes from 192.168.1.35: icmp_seq=4 ttl=64 time=2.84 ms
```

If the previous connection succeeded, then we can proceed to the next step of using SSH:

```bash
ssh homeserver@192.168.1.35
```

You should expect an output requesting a password like this:

```bash
(homeserver@192.168.1.35) Password: 
```

You will need to use the password for the homeserver, which is the same as your login password for Home Assistant.

The expected output will be something like this:

```bash
[homeserver@nixos:~/Desktop/homeserver]$ 
```

And it is the terminal of the homeserver! Congratulations, you now have access!

However, this method is not very user-friendly. So instead, let's use Visual Studio Code and Remote SSH to get a graphical user interface. Find and open Visual Studio Code on your computer. Once open, click the `><` symbol at the bottom left of the window, select "Connect to Host," and then choose `192.168.1.35`. This will open a window and ask for a password. You will enter the same password as when using SSH, which is also the same as your Home Assistant login. Visual Studio Code will now display a mostly empty window. That's because you have to tell VS Code which folder to look into. You can find the project under `/home/homeserver/Desktop/homeserver`. Navigate to it using the input field and open it up.

For a more detailed guide, visit the official documentation: [Visual Studio Code - Remote SSH](https://code.visualstudio.com/docs/remote/ssh#_connect-to-a-remote-host).

## Description

The following will be an explanation of the different services run on the home server, but before that, let's give a small introduction to how these services are run. All services are run in Docker containers. A Docker container is essentially an isolated virtual machine where some program is allowed to live and do its thing. This program will usually have a port like `1880` available for other services or users to interact with it. This port is, however, not accessible on the host system (the PC) because all Docker images are run within an isolated Docker network. You can see a Docker network like a normal LAN network, where many Docker containers in a Docker network are equivalent to many gaming PCs hooked together in a LAN setup.

So, since the Docker network is not accessible by default, we will have to specify which ports we want to expose to our host PC. This will usually be done with a string in the following format `"1880:1880"`, which says "Point port 1880 inside of the container to port 1880 on the host system." You, the user, will then be able to access the program running inside the container by visiting the site at `http://192.168.1.35:1880`. Where `192.168.1.35` describes the static IP set for the home server and `1880` describes the port Node-RED exposes to the host system.

To manage all of these Docker containers, we will use a Docker Compose file to describe how to run the Docker containers. I won't go into all the details as it is quite extensive, so let's instead look at an example of the Node-RED service. Below we have a valid [Docker Compose file](compose.yaml) for creating a Node-RED service.

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

In this example, we're setting up a Node-RED service. The 'image' part tells Docker which container image to use, in this case, the official Node-RED image. 'restart: unless-stopped' means the container will always restart unless you manually stop it. The 'ports' section is where we specify which ports to expose, just like we talked about earlier. Here, we're exposing port 1880, which is the default port for Node-RED's web interface.

The 'volumes' part is a bit like connecting an external hard drive to your container. It lets the container access a folder on your actual computer. Here, we're connecting a local folder `./nodered/data` to the `/data` folder inside the container. This way, even if you stop or delete the container, your Node-RED settings will still be there when you start it up again.

This is just the simplest example; you can find three more services in the compose.yaml, which I encourage you to look at as it is the backbone of the homeserver.

## FAQ

### Why do we use Cloudflare Tunnels?

Cloudflare Tunnels, managed by the `cloudflared` service, allow secure access to our homeserver’s internal services from anywhere without exposing our network to the internet. Instead of dealing with port forwarding, `cloudflared` creates a secure, outbound-only connection from our homeserver to Cloudflare's network. This way, external requests are routed through Cloudflare's secure tunnel, ensuring that our local services are protected while still accessible remotely. This method enhances security and simplifies remote access, making our homeserver setup both safe and easy to manage.

### What should I do if a service isn't working?

If a service isn't working, the first step is to check if its Docker container is running. You can do this by using the `docker ps` command to list all active containers. If the container is not listed, try restarting the service using `docker compose restart <service_name>`. If the issue persists, checking the logs with `docker logs <container_name>` can provide more details on what's going wrong.

## Common Commands

Start Docker containers:

```bash
docker compose up -d
```

Stop Docker containers:

```bash
docker compose down
```

View running containers:

```bash
docker ps
```

Check container logs:

```bash
docker logs <container_name>
```

Restart a specific service:

```bash
docker compose restart <service_name>
```