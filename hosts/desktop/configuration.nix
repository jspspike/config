{ config, pkgs, inputs, ... }:

let
  androidMessages = pkgs.callPackage "${inputs.pineapple}/pkgs/android-messages.nix" {};
in
{
  imports =
    [ ./hardware-configuration.nix ../../machine-modules/common.nix ../../machine-modules/sway.nix ];

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify androidMessages ];

  services = {
    libinput = {
      mouse = {
        accelProfile = "flat";
      };
    };
  };
}
