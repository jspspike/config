{ config, pkgs, inputs, self, ... }:

{ imports = [
    ./hardware-configuration.nix
    ../../machine-modules/sway.nix
    ../../machine-modules/common.nix
    ../../machine-modules/ssh.nix
    ../../secrets/config.nix
    ./ddns.nix
    ./dns.nix
    ./immich.nix
    ./rustic.nix
    ../../machine-modules/rustic-server.nix
    ../../machine-modules/mullvad.nix
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

    # Calm Hare
    mullvad-netns = {
      enable = true;
      privateKeyFile = config.age.secrets.wg-private-media.path;
      addressV4 = "10.67.82.6/32";
      addressV6 = "fc00:bbbb:bbbb:bb01::4:5205/128";
      dnsIp = "100.64.0.5";
    };

    rustic-server = {
      enable = true;

      package = self.packages.x86_64-linux.rustic-server;
      # Configuration
      listenAddress = "0.0.0.0";
      port = 8000;
      dataDir = "/var/lib/rustic/backup";

      # File paths
      aclFile = ./acl.toml;
      htpasswdFile = config.age.secrets.rustic-media-htpasswd.path;
    };

  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53 80 ];
      allowedUDPPorts = [ 53 80 ];
    };

    networkmanager = {
      enable = true;
      wifi.powersave = false;

      settings = {
        device = {
          "wifi.scan-rand-mac-address" = "no";
        };

        connection = {
          "wifi.cloned-mac-address" = "permanent";
          "ethernet.cloned-mac-address" = "permanent";
        };
      };
    };
  };
}
