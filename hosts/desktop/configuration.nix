{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ../../machine-modules/common.nix
    ../../machine-modules/sway.nix
    ../../secrets/config.nix
    ../../machine-modules/rustic-server.nix
    ./rustic-server.nix
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
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8000 ];
  };
}
