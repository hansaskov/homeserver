{ config, pkgs, lib, ... }:

let
  opencodeVersion = "2.2.5";
  opencodeWebPort = 4096;

  opencode-baseline = pkgs.stdenvNoCC.mkDerivation {
    pname = "opencode-baseline";
    version = opencodeVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/sst/opencode/releases/download/v${opencodeVersion}/opencode-linux-x64-baseline.tar.gz";
      hash = "sha256-CfRDAsEP0DaRL1nIH9Gu9d9F3Qb2SRl/nfybvip5YU4=";
    };

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;   # stripping/patching corrupts Bun-compiled binaries
    dontFixup = true;

    installPhase = ''
      install -Dm755 opencode $out/bin/opencode
    '';
  };

  # Serves the OpenCode web UI on the LAN. A password is generated once and
  # stored in /var/lib/opencode-web/password so browser logins keep working
  # across reboots and service restarts.
  opencode-web-start = pkgs.writeShellScript "opencode-web-start" ''
    set -eu
    umask 077
    password_file=/var/lib/opencode-web/password
    if [ ! -s "$password_file" ]; then
      ${pkgs.coreutils}/bin/head -c 32 /dev/urandom \
        | ${pkgs.coreutils}/bin/base64 -w 0 > "$password_file"
    fi
    export OPENCODE_PASSWORD="$(${pkgs.coreutils}/bin/cat "$password_file")"
    exec ${opencode-baseline}/bin/opencode serve \
      --hostname 0.0.0.0 \
      --port ${toString opencodeWebPort}
  '';
in

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # System Configuration
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Boot Configuration
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    wireless.enable = false;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 1883 8123 1880 opencodeWebPort ];
    };
    nameservers = ["1.1.1.1" "8.8.8.8"];
    defaultGateway = "192.168.1.1";    
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.35";
        prefixLength = 24;
      }];
    };
  };

  # Localization
  time.timeZone = "Europe/Copenhagen";

  # User Management
  users.users.homeserver = {
    isNormalUser = true;
    description = "Hans Askov";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Allow members of the "wheel" group (homeserver) to run sudo without a
  # password. This keeps unattended maintenance and tooling from stalling on a
  # password prompt. Every process running as homeserver can now become root.
  security.sudo.wheelNeedsPassword = false;

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    docker
    opencode-baseline
  ];

  # System Services
  services.openssh.enable = true;

  # OpenCode web UI, reachable on the home network at
  # http://192.168.1.35:4096 (password: /var/lib/opencode-web/password).
  systemd.services.opencode-web = {
    description = "OpenCode web interface";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "homeserver";
      Group = "users";
      WorkingDirectory = "/home/homeserver/Desktop/homeserver";
      StateDirectory = "opencode-web";
      StateDirectoryMode = "0700";
      RuntimeDirectory = "opencode-web";
      Environment = [
        "HOME=/home/homeserver"
        "XDG_RUNTIME_DIR=/run/opencode-web"
      ];
      ExecStart = opencode-web-start;
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Virtualization
  virtualisation.docker.enable = true;

  # Additional Programs
  programs.nix-ld = {
    enable = true;
    libraries = [ pkgs.stdenv.cc.cc.lib ];
  };
}
