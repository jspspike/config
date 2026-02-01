{ config, pkgs, inputs, self, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ../../machine-modules/common.nix
    ../../machine-modules/sway.nix
    ../../secrets/config.nix
    ../../machine-modules/rustic-server.nix
    ../../machine-modules/mullvad.nix
  ];

  programs = {
    steam.enable = true;
  };

  users.users.jspspike = {
    packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];
  };

  services = {
    libinput = {
      mouse = {
        accelProfile = "flat";
      };
    };

    # Social Kiwi
    mullvad-netns = {
      enable = true;
      privateKeyFile = config.age.secrets.wg-private-desktop.path;
      addressV4 = "10.73.9.39/32";
      addressV6 = "fc00:bbbb:bbbb:bb01::a:926/128";
      dnsIp = "100.64.0.5";
    };

    rustic-server = {
      enable = true;

      # Optional: Override the package if you want the specific one from your flake inputs
      package = self.packages.x86_64-linux.rustic-server;

      # Configuration
      listenAddress = "0.0.0.0";
      port = 8000;
      dataDir = "/var/lib/rustic/backup";

      # File paths
      aclFile = ./acl.toml;
      htpasswdFile = config.age.secrets.rustic-desktop-htpasswd.path;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8000 ];
    };

    networkmanager = {
      enable = true;
      wifi.powersave = false;
      unmanaged = [ "wlp3s0" ];

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
