{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ../../machine-modules/common.nix ../../machine-modules/sway.nix ];

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
