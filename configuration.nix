{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # System Configuration
  system.stateVersion = "23.11";
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
      allowedTCPPorts = [ 22 1883 8123 1880 ];
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

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    docker
  ];

  # System Services
  services.openssh.enable = true;

  # Virtualization
  virtualisation.docker.enable = true;

  # Additional Programs
  programs.nix-ld.enable = true;
}
