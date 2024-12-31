{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ../../machine-modules/i3.nix ../../machine-modules/common.nix ];

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];
}