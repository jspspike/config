{ config, pkgs, inputs, ... }:

let
  androidMessages = pkgs.callPackage "${inputs.pineapple}/pkgs/android-messages.nix" {};
in
{
  imports =
    [ ./hardware-configuration.nix ../../machine-modules/i3.nix ../../machine-modules/common.nix ];

  environment.extraInit = ''
    xset s off -dpms
  '';

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify androidMessages ];
}
