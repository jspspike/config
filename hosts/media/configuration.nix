{ config, pkgs, inputs, ... }:
{ imports = [ ./hardware-configuration.nix ../../machine-modules/i3.nix ../../machine-modules/common.nix ]; environment.extraInit = ''
    autorandr --change
    xset s off -dpms
  '';

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify ];

  services = {
    libinput = {
      mouse = {
        accelProfile = "flat";
      };
    };
  };
}
