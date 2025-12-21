{ config, pkgs, inputs, lib, ... }:

{ imports = [
    ./hardware-configuration.nix
    ../../machine-modules/sway.nix
    ../../machine-modules/common.nix
    ../../machine-modules/ssh.nix
    ../../secrets/config.nix
    ./ddns.nix
    ./dns.nix
    ./immich.nix
  ];
  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages mullvad-vpn qbittorrent vlc ];

  services = {
    libinput = {
      mouse = {
        accelProfile = "flat";
      };
    };
    nginx = {
      enable = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 80 ];
    allowedUDPPorts = [ 53 80 ];
  };
}
