# Homeserver for Askov

This is the home server. It runs the smart home, and it runs an AI helper
called an **agent** that can make changes to the server for you.

The server is a small computer at Jan's home. On the home network,
its address is `192.168.1.35`.

## Start here: ask the agent

You do not need to know anything about coding, terminals, or servers.

1. Make sure your computer, tablet, or phone is connected to the same Wi-Fi
   network as the server.
2. Open a web browser (for example Chrome, Safari, Edge, or Firefox).
3. Type this address into the address bar and press Enter:

   <http://192.168.1.35:4096>

4. A login screen appears.
   - Username: `opencode`
   - Password: ask Hans for the password.
5. You will see a chat window. Type what you want in normal language.
   For example:
   - "Is Home Assistant working?"
   - "Restart Home Assistant."
   - "The living room light is not responding. Please check why."
6. The agent will do the work and explain what it did. If it needs a decision
   from you, it will ask.

The agent can read and change files, restart services, and check what is
wrong. Only give it instructions you are comfortable with.

> **Keep the password private.** Anyone who has it can control the server.
> The agent page only works on the home network, not from the internet.

## What the server runs

| Service | Open it at | What it is |
| --- | --- | --- |
| **OpenCode** | <http://192.168.1.35:4096> | The AI agent. This is the main way to get things done. |
| **Home Assistant** | <http://192.168.1.35:8123> | The smart home dashboard. Use it to turn devices on and off and see their status. |

Home Assistant can also be reached from outside the home through a secure
Cloudflare connection. Ask Hans for the address.

## If something is not working

1. Open the agent page (<http://192.168.1.35:4096>) and describe the problem.
   For example: "Home Assistant is not loading. Please fix it."
2. If the agent page does not open, the server may be turned off or
   disconnected from the network. Check that the server is on and connected
   to the router.
3. If it still does not work, contact Hans.

## Technical details (you can skip this)

The agent handles day-to-day maintenance. These are the files it works with:

- `compose.yaml` — the Docker services: Home Assistant, Mosquitto, and the
  Cloudflare Tunnel.
- `configuration.nix` — the NixOS system settings, including the OpenCode
  service and the firewall.
- `.env` — the Cloudflare Tunnel token.

OpenCode runs as the system service `opencode-web` on port `4096`. If the
agent page itself will not start, a technical person can restart it with:

```bash
sudo systemctl restart opencode-web
```
